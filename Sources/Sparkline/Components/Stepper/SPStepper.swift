import SwiftUI

/// A progress indicator for multi-step flows: numbered steps with labels,
/// horizontal or vertical. Display only.
///
/// Not to be confused with SwiftUI's `Stepper` (a +/- control).
///
/// ```swift
/// SPStepper(steps: [
///     .init("Choose CD"), .init("Personal info"), .init("Verify identity"),
///     .init("Fund account"), .init("Review"),
/// ], activeStep: 1)
/// ```
public struct SPStepper: View {
    public enum StepState: String, CaseIterable, Sendable {
        case pending, active, completed, error
    }

    public enum Orientation: String, CaseIterable, Sendable {
        case horizontal, vertical
    }

    /// One step.
    public struct Step: Sendable {
        public let label: String
        public let description: String?
        /// Overrides the automatic state, e.g. to flag an error.
        public let state: StepState?

        public init(_ label: String, description: String? = nil, state: StepState? = nil) {
            self.label = label
            self.description = description
            self.state = state
        }
    }

    let steps: [Step]
    let activeStep: Int
    let orientation: Orientation

    /// - Parameters:
    ///   - steps: Three to six steps.
    ///   - activeStep: Zero-based index of the current step. Earlier steps show as
    ///     completed, later ones as pending.
    ///   - orientation: `.horizontal` or `.vertical`.
    public init(steps: [Step], activeStep: Int = 0, orientation: Orientation = .horizontal) {
        self.steps = steps
        self.activeStep = activeStep
        self.orientation = orientation
    }

    func state(at index: Int) -> StepState {
        if let explicit = steps[index].state { return explicit }
        if index < activeStep { return .completed }
        if index == activeStep { return .active }
        return .pending
    }

    public var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                HStack(alignment: .top, spacing: 0) {
                    ForEach(steps.indices, id: \.self) { index in
                        horizontalStep(steps[index], index: index)
                    }
                }
            case .vertical:
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(steps.indices, id: \.self) { index in
                        verticalStep(steps[index], index: index)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: activeStep)
    }

    private func horizontalStep(_ step: Step, index: Int) -> some View {
        let s = state(at: index)
        return VStack(spacing: SPSpacing.xs) {
            HStack(spacing: 0) {
                StepIndicator(number: index + 1, state: s)
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(connectorColor(s))
                        .frame(height: 2)
                        .padding(.horizontal, SPSpacing.xs)
                }
            }
            content(step, state: s)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SPSpacing.xs)
        }
        .frame(maxWidth: .infinity)
        .modifier(StepAccessibility(step: step, index: index, count: steps.count, state: s))
    }

    private func verticalStep(_ step: Step, index: Int) -> some View {
        let s = state(at: index)
        return HStack(alignment: .top, spacing: SPSpacing.sm) {
            VStack(spacing: 0) {
                StepIndicator(number: index + 1, state: s)
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(connectorColor(s))
                        .frame(width: 2)
                        .frame(minHeight: 32, maxHeight: .infinity)
                        .padding(.vertical, SPSpacing.xs)
                }
            }
            content(step, state: s)
                .padding(.top, 2)
                .padding(.bottom, SPSpacing.lg)
            Spacer(minLength: 0)
        }
        .fixedSize(horizontal: false, vertical: true)
        .modifier(StepAccessibility(step: step, index: index, count: steps.count, state: s))
    }

    private func content(_ step: Step, state: StepState) -> some View {
        VStack(alignment: orientation == .horizontal ? .center : .leading, spacing: 2) {
            Text(step.label)
                .spTextStyle(.body2)
                .fontWeight(state == .active ? .bold : .medium)
                .foregroundStyle(labelColor(state))
            if let description = step.description {
                Text(description)
                    .spTextStyle(.caption)
                    .foregroundStyle(.spTextSecondary)
            }
        }
    }

    private func connectorColor(_ state: StepState) -> Color {
        state == .completed ? .spSurfaceBrand : .spBorderSubtle
    }

    private func labelColor(_ state: StepState) -> Color {
        switch state {
        case .active, .completed: return .spTextPrimary
        case .error: return .spTextError
        case .pending: return .spTextSecondary
        }
    }
}

private struct StepIndicator: View {
    let number: Int
    let state: SPStepper.StepState

    var body: some View {
        let (border, fill, foreground): (Color, Color, Color) = {
            switch state {
            case .active: return (.spSurfaceBrand, .spSurfaceBrand, .spTextInverse)
            case .completed: return (.spSurfaceBrand, .clear, .spSurfaceBrand)
            case .error: return (.spBorderError, .clear, .spSurfaceError)
            case .pending: return (.spBorderSubtle, .clear, .spTextSecondary)
            }
        }()
        ZStack {
            Circle().fill(fill)
            Circle().strokeBorder(border, lineWidth: 2)
            switch state {
            case .completed: SPIcon(.checkCircleOutline, size: 20)
            case .error: SPIcon(.alertCircleOutline, size: 20)
            case .active, .pending:
                Text("\(number)").spTextStyle(.caption).fontWeight(.bold)
            }
        }
        .foregroundStyle(foreground)
        .frame(width: 28, height: 28)
    }
}

/// Reads each step as "Step 2 of 5, Personal info, current".
private struct StepAccessibility: ViewModifier {
    let step: SPStepper.Step
    let index: Int
    let count: Int
    let state: SPStepper.StepState

    func body(content: Content) -> some View {
        let status: String = {
            switch state {
            case .active: return "current"
            case .completed: return "completed"
            case .error: return "error"
            case .pending: return "not started"
            }
        }()
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(index + 1) of \(count), \(step.label)")
            .accessibilityValue([step.description, status].compactMap { $0 }.joined(separator: ", "))
    }
}

struct SPStepper_Previews: PreviewProvider {
    static let steps: [SPStepper.Step] = [
        .init("Choose CD"), .init("Personal info"), .init("Verify identity", state: .error), .init("Review"),
    ]

    static var previews: some View {
        VStack(spacing: SPSpacing.xl) {
            SPStepper(steps: steps, activeStep: 1)
            SPStepper(steps: [
                .init("Choose CD", description: "12-month CD"),
                .init("Personal info", description: "Name and address"),
                .init("Fund account"),
            ], activeStep: 1, orientation: .vertical)
        }
        .padding()
    }
}
