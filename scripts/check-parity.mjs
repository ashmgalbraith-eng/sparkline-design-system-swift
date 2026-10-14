// Checks that every Angular component input and output has a Swift equivalent.
//
// Reads @Input()/@Output() names from ../sparkline-design-system/src/app/components/*/*.component.ts
// and compares them with parity.json. Fails when the web adds, renames or removes one
// without a matching parity.json entry, or when a mapped Swift parameter label no longer
// exists in the Swift component. Writes docs/parity.md from parity.json.
//
// Usage: node scripts/check-parity.mjs [path/to/sparkline-design-system]

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const web = process.argv[2] ?? join(root, '../sparkline-design-system');
const webComponents = join(web, 'src/app/components');
const swiftComponents = join(root, 'Sources/Sparkline/Components');
const { components } = JSON.parse(readFileSync(join(root, 'parity.json'), 'utf8'));

// Swift source by public type name, e.g. SPButton -> its file's text.
const swiftSources = new Map();
for (const dir of readdirSync(swiftComponents)) {
  for (const file of readdirSync(join(swiftComponents, dir)).filter((f) => f.endsWith('.swift'))) {
    const text = readFileSync(join(swiftComponents, dir, file), 'utf8');
    for (const m of text.matchAll(/public struct (\w+)/g)) swiftSources.set(m[1], text);
  }
}

const errors = [];
const webNames = readdirSync(webComponents).filter((d) => existsSync(join(webComponents, d, `${d}.component.ts`)));

for (const name of webNames) {
  const ts = readFileSync(join(webComponents, name, `${name}.component.ts`), 'utf8');
  const actual = {
    inputs: [...ts.matchAll(/@Input\(\)\s+(\w+)/g)].map((m) => m[1]),
    outputs: [...ts.matchAll(/@Output\(\)\s+(\w+)/g)].map((m) => m[1]),
  };
  const entry = components[name];
  if (!entry) {
    errors.push(`${name}: Angular component has no entry in parity.json`);
    continue;
  }
  const source = swiftSources.get(entry.swift);
  if (!source) errors.push(`${name}: Swift type ${entry.swift} not found`);

  for (const kind of ['inputs', 'outputs']) {
    const mapped = entry[kind] ?? {};
    for (const prop of actual[kind]) {
      const map = mapped[prop];
      if (!map) {
        errors.push(`${name}: Angular ${kind.slice(0, -1)} "${prop}" is not mapped in parity.json`);
      } else if (map.swift && source && !source.includes(`${map.swift}:`)) {
        errors.push(`${name}: "${prop}" maps to Swift "${map.swift}:", which ${entry.swift} doesn't have`);
      }
    }
    for (const prop of Object.keys(mapped)) {
      if (!actual[kind].includes(prop)) errors.push(`${name}: parity.json maps "${prop}", which Angular no longer has`);
    }
  }
}
for (const name of Object.keys(components)) {
  if (!webNames.includes(name)) errors.push(`${name}: in parity.json but not in the Angular library`);
}

// docs/parity.md
const md = [
  '# Angular ↔ Swift parity',
  '',
  'Generated from `parity.json` by `scripts/check-parity.mjs`. Do not edit by hand.',
  '',
  'Every input and output of the Angular library, and its Swift equivalent. Names match where Swift allows;',
  'booleans read as `is…`/`shows…`, values are Bindings, and disabled is the standard `.disabled(_:)` modifier.',
  '"Native" means iOS provides it without a parameter.',
  '',
];
for (const [name, entry] of Object.entries(components)) {
  md.push(`## ${name} → \`${entry.swift}\``, '', '| Angular | Swift | Notes |', '|---|---|---|');
  for (const [kind, label] of [['inputs', ''], ['outputs', ' (output)']]) {
    for (const [prop, map] of Object.entries(entry[kind] ?? {})) {
      const swift = map.swift ? `\`${map.swift.replace(/^_ /, '')}${map.swift.startsWith('_ ') ? ' (first argument)' : ''}\`` : 'Native';
      md.push(`| \`${prop}\`${label} | ${swift} | ${map.native ?? map.note ?? ''} |`);
    }
  }
  md.push('');
}
writeFileSync(join(root, 'docs/parity.md'), md.join('\n'));

if (errors.length) {
  console.error(`Parity check failed:\n  ${errors.join('\n  ')}`);
  process.exit(1);
}
const total = Object.values(components).reduce((n, c) => n + Object.keys(c.inputs).length + Object.keys(c.outputs).length, 0);
console.log(`Parity: ${webNames.length} components, ${total} inputs and outputs mapped -> docs/parity.md`);
