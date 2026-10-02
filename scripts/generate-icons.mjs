// Generates Sparkline's icon set from the Angular icon registry.
//
// Source of truth: ../sparkline-design-system/src/app/components/icon/icon-registry.ts
// (24×24 SVG path strings keyed by name).
//
// Writes Sources/Sparkline/Components/Icon/SPIconName+Generated.swift:
//   SPIconName            one case per icon, raw value = the registry key
//   SPIconName.path(in:)  the icon drawn as a SwiftUI Path, scaled to a rect
//
// SVG paths are converted to absolute move/line/quad/cubic commands at build
// time (arcs become cubic Béziers), so no SVG parsing happens at runtime.
//
// Usage: node scripts/generate-icons.mjs [path/to/icon-registry.ts]

import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const registryPath =
  process.argv[2] ?? join(root, '../sparkline-design-system/src/app/components/icon/icon-registry.ts');
const outPath = join(root, 'Sources/Sparkline/Components/Icon/SPIconName+Generated.swift');

const source = readFileSync(registryPath, 'utf8');
const icons = [...source.matchAll(/'([\w-]+)':\s*'([^']+)'/g)].map((m) => ({ name: m[1], d: m[2] }));
if (!icons.length) throw new Error(`No icons found in ${registryPath}`);

// ── SVG path parsing ────────────────────────────────────────────────────────

function tokenize(d) {
  const tokens = [];
  const re = /([MmLlHhVvCcSsQqTtAaZz])|(-?(?:\d+\.?\d*|\.\d+)(?:e[-+]?\d+)?)/g;
  let m;
  while ((m = re.exec(d))) tokens.push(m[1] ?? Number(m[2]));
  return tokens;
}

// Arc flags may be written without separators ("0 01 16 8"), so read them one digit at a time.
function splitArcFlags(d) {
  return d.replace(/([Aa])([^MmLlHhVvCcSsQqTtAaZz]*)/g, (_, cmd, args) => {
    const nums = [];
    const re = /-?(?:\d+\.?\d*|\.\d+)(?:e[-+]?\d+)?/g;
    let i = 0;
    let m;
    while ((m = re.exec(args))) {
      const slot = i % 7;
      if ((slot === 3 || slot === 4) && m[0].length > 1 && /^[01]/.test(m[0])) {
        nums.push(m[0][0]);
        re.lastIndex = m.index + 1;
      } else {
        nums.push(m[0]);
      }
      i++;
    }
    return cmd + ' ' + nums.join(' ') + ' ';
  });
}

function arcToCubics(x1, y1, rx, ry, phiDeg, largeArc, sweep, x2, y2) {
  if (rx === 0 || ry === 0) return [['L', x2, y2]];
  const phi = (phiDeg * Math.PI) / 180;
  const cos = Math.cos(phi);
  const sin = Math.sin(phi);
  const dx = (x1 - x2) / 2;
  const dy = (y1 - y2) / 2;
  const x1p = cos * dx + sin * dy;
  const y1p = -sin * dx + cos * dy;
  rx = Math.abs(rx);
  ry = Math.abs(ry);
  const lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
  if (lambda > 1) {
    rx *= Math.sqrt(lambda);
    ry *= Math.sqrt(lambda);
  }
  const num = rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p;
  const den = rx * rx * y1p * y1p + ry * ry * x1p * x1p;
  let coef = Math.sqrt(Math.max(0, num / den));
  if (largeArc === sweep) coef = -coef;
  const cxp = (coef * (rx * y1p)) / ry;
  const cyp = (coef * -(ry * x1p)) / rx;
  const cx = cos * cxp - sin * cyp + (x1 + x2) / 2;
  const cy = sin * cxp + cos * cyp + (y1 + y2) / 2;

  const angle = (ux, uy, vx, vy) => {
    const dot = ux * vx + uy * vy;
    const len = Math.hypot(ux, uy) * Math.hypot(vx, vy);
    let a = Math.acos(Math.min(1, Math.max(-1, dot / len)));
    if (ux * vy - uy * vx < 0) a = -a;
    return a;
  };
  const theta1 = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
  let delta = angle((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry);
  if (!sweep && delta > 0) delta -= 2 * Math.PI;
  if (sweep && delta < 0) delta += 2 * Math.PI;

  const segments = Math.ceil(Math.abs(delta) / (Math.PI / 2));
  const step = delta / segments;
  const k = (4 / 3) * Math.tan(step / 4);
  const out = [];
  const point = (t) => [
    cx + rx * Math.cos(t) * cos - ry * Math.sin(t) * sin,
    cy + rx * Math.cos(t) * sin + ry * Math.sin(t) * cos,
  ];
  const deriv = (t) => [
    -rx * Math.sin(t) * cos - ry * Math.cos(t) * sin,
    -rx * Math.sin(t) * sin + ry * Math.cos(t) * cos,
  ];
  let t = theta1;
  for (let i = 0; i < segments; i++) {
    const t2 = t + step;
    const [px, py] = point(t);
    const [qx, qy] = point(t2);
    const [dx1, dy1] = deriv(t);
    const [dx2, dy2] = deriv(t2);
    out.push(['C', px + k * dx1, py + k * dy1, qx - k * dx2, qy - k * dy2, qx, qy]);
    t = t2;
  }
  // Snap the final point exactly to the arc's endpoint.
  const last = out[out.length - 1];
  last[5] = x2;
  last[6] = y2;
  return out;
}

const ARITY = { M: 2, L: 2, H: 1, V: 1, C: 6, S: 4, Q: 4, T: 2, A: 7, Z: 0 };

function toAbsolute(d) {
  const tokens = tokenize(splitArcFlags(d));
  const ops = [];
  let i = 0;
  let cmd = null;
  let x = 0, y = 0, sx = 0, sy = 0;
  let lastCtrl = null; // [x, y, kind] for S/T reflection
  while (i < tokens.length) {
    if (typeof tokens[i] === 'string') cmd = tokens[i++];
    else if (cmd === null) throw new Error(`Path starts without a command: ${d}`);
    const up = cmd.toUpperCase();
    const rel = cmd !== up;
    if (up === 'Z') {
      ops.push(['Z']);
      x = sx; y = sy;
      lastCtrl = null;
      continue;
    }
    const args = tokens.slice(i, i + ARITY[up]);
    if (args.length < ARITY[up] || args.some((a) => typeof a !== 'number')) throw new Error(`Bad args for ${cmd} in ${d}`);
    i += ARITY[up];
    const ax = (v) => (rel ? x + v : v);
    const ay = (v) => (rel ? y + v : v);
    switch (up) {
      case 'M': {
        x = ax(args[0]); y = ay(args[1]);
        sx = x; sy = y;
        ops.push(['M', x, y]);
        cmd = rel ? 'l' : 'L'; // implicit lineto after the first pair
        lastCtrl = null;
        break;
      }
      case 'L': x = ax(args[0]); y = ay(args[1]); ops.push(['L', x, y]); lastCtrl = null; break;
      case 'H': x = rel ? x + args[0] : args[0]; ops.push(['L', x, y]); lastCtrl = null; break;
      case 'V': y = rel ? y + args[0] : args[0]; ops.push(['L', x, y]); lastCtrl = null; break;
      case 'C': {
        const c = [ax(args[0]), ay(args[1]), ax(args[2]), ay(args[3]), ax(args[4]), ay(args[5])];
        ops.push(['C', ...c]);
        lastCtrl = [c[2], c[3], 'C'];
        x = c[4]; y = c[5];
        break;
      }
      case 'S': {
        const [c1x, c1y] = lastCtrl?.[2] === 'C' ? [2 * x - lastCtrl[0], 2 * y - lastCtrl[1]] : [x, y];
        const c = [ax(args[0]), ay(args[1]), ax(args[2]), ay(args[3])];
        ops.push(['C', c1x, c1y, ...c]);
        lastCtrl = [c[0], c[1], 'C'];
        x = c[2]; y = c[3];
        break;
      }
      case 'Q': {
        const c = [ax(args[0]), ay(args[1]), ax(args[2]), ay(args[3])];
        ops.push(['Q', ...c]);
        lastCtrl = [c[0], c[1], 'Q'];
        x = c[2]; y = c[3];
        break;
      }
      case 'T': {
        const [qx, qy] = lastCtrl?.[2] === 'Q' ? [2 * x - lastCtrl[0], 2 * y - lastCtrl[1]] : [x, y];
        const ex = ax(args[0]), ey = ay(args[1]);
        ops.push(['Q', qx, qy, ex, ey]);
        lastCtrl = [qx, qy, 'Q'];
        x = ex; y = ey;
        break;
      }
      case 'A': {
        const ex = ax(args[5]), ey = ay(args[6]);
        ops.push(...arcToCubics(x, y, args[0], args[1], args[2], !!args[3], !!args[4], ex, ey));
        x = ex; y = ey;
        lastCtrl = null;
        break;
      }
    }
  }
  return ops;
}

// ── Swift output ────────────────────────────────────────────────────────────

const n = (v) => {
  const r = Math.round(v * 1000) / 1000;
  return Object.is(r, -0) ? '0' : String(r);
};
const pt = (x, y) => `p(${n(x)}, ${n(y)})`;

function swiftOps(ops) {
  return ops.map((op) => {
    switch (op[0]) {
      case 'M': return `path.move(to: ${pt(op[1], op[2])})`;
      case 'L': return `path.addLine(to: ${pt(op[1], op[2])})`;
      case 'Q': return `path.addQuadCurve(to: ${pt(op[3], op[4])}, control: ${pt(op[1], op[2])})`;
      case 'C': return `path.addCurve(to: ${pt(op[5], op[6])}, control1: ${pt(op[1], op[2])}, control2: ${pt(op[3], op[4])})`;
      case 'Z': return 'path.closeSubpath()';
    }
    throw new Error(`Unknown op ${op[0]}`);
  });
}

const camel = (s) => s.replace(/-(\w)/g, (_, c) => c.toUpperCase());
const reserved = new Set(['default', 'switch', 'case', 'for', 'in', 'repeat', 'return']);
const caseName = (s) => (reserved.has(camel(s)) ? `\`${camel(s)}\`` : camel(s));

const lines = [];
lines.push('// GENERATED by scripts/generate-icons.mjs from sparkline-design-system/src/app/components/icon/icon-registry.ts.');
lines.push('// Do not edit by hand. Re-run `node scripts/generate-icons.mjs` after changing the icon registry.');
lines.push('');
lines.push('import SwiftUI');
lines.push('');
lines.push(`/// Every icon in the Sparkline registry (${icons.length} icons). Raw values match the web registry keys.`);
lines.push('public enum SPIconName: String, CaseIterable, Sendable, Identifiable {');
for (const icon of icons) lines.push(`    case ${caseName(icon.name)} = "${icon.name}"`);
lines.push('');
lines.push('    public var id: String { rawValue }');
lines.push('');
lines.push('    /// The icon drawn on its 24×24 grid, scaled to fit `rect`.');
lines.push('    public func path(in rect: CGRect) -> Path {');
lines.push('        let s = min(rect.width, rect.height) / 24');
lines.push('        let ox = rect.minX + (rect.width - 24 * s) / 2');
lines.push('        let oy = rect.minY + (rect.height - 24 * s) / 2');
lines.push('        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: ox + x * s, y: oy + y * s) }');
lines.push('        var path = Path()');
lines.push('        switch self {');
for (const icon of icons) {
  lines.push(`        case .${caseName(icon.name).replace(/`/g, '')}:`);
  for (const l of swiftOps(toAbsolute(icon.d))) lines.push(`            ${l}`);
}
lines.push('        }');
lines.push('        return path');
lines.push('    }');
lines.push('}');
lines.push('');

writeFileSync(outPath, lines.join('\n'));
console.log(`Icons: ${icons.length} icons -> ${outPath.replace(root + '/', '')}`);
