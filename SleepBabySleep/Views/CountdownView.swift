import SwiftUI

/// Countdown display shown when a timer is active
struct CountdownView: View {
    @ObservedObject var viewModel: SleepTimerViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Mode label
            if let mode = viewModel.currentMode {
                Text(modeDescription(mode))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Circular progress + countdown
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.primary.opacity(0.08), lineWidth: 8)
                
                // Progress arc with gradient
                Circle()
                    .trim(from: 0, to: 1 - viewModel.progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [timerColor.opacity(0.6), timerColor]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: viewModel.progress)
                    .shadow(color: timerColor.opacity(0.3), radius: 8, x: 0, y: 0)
                
                // Time text
                VStack(spacing: 2) {
                    Text(viewModel.timeRemainingFormatted)
                        .font(.system(size: 34, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .shadow(color: timerColor.opacity(0.2), radius: 2, x: 0, y: 0)
                    
                    Text(NSLocalizedString("countdown.remaining", value: "remaining", comment: "Remaining label"))
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                }
            }
            .frame(width: 150, height: 150)
            
            // Warning indicator
            if viewModel.warningSent {
                Label(
                    NSLocalizedString("countdown.sleepingSoon", value: "Sleeping soon...", comment: "Sleeping soon warning"),
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.caption)
                .foregroundStyle(.orange)
                .transition(.opacity)
            }
            
            // Cancel button
            Button(action: {
                viewModel.cancel()
            }) {
                Label(
                    NSLocalizedString("action.cancel", value: "Cancel", comment: "Cancel button"),
                    systemImage: "xmark.circle.fill"
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
        }
        .animation(.easeInOut, value: viewModel.warningSent)
    }
    
    // MARK: - Helpers
    
    /// Color changes to orange/red as time runs out
    private var timerColor: Color {
        if viewModel.secondsRemaining <= 30 {
            return .red
        } else if viewModel.secondsRemaining <= 60 {
            return .orange
        } else {
            return .accentColor
        }
    }
    
    /// Description of the current timer mode
    private func modeDescription(_ mode: SleepMode) -> String {
        switch mode {
        case .preset(let minutes):
            return String(
                format: NSLocalizedString("countdown.preset", value: "%d minute timer", comment: "Preset timer description"),
                minutes
            )
        case .dateTime(let date):
            return String(
                format: NSLocalizedString("countdown.scheduled", value: "Scheduled for %@", comment: "Scheduled time description"),
                Self.timeFormatter.string(from: date)
            )
        }
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()
}
