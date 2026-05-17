import SwiftUI

/// Grid of preset timer buttons (10, 15, 30, 45 minutes)
struct TimerPresetsView: View {
    @ObservedObject var viewModel: SleepTimerViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(
                NSLocalizedString("section.quickTimer", value: "Quick Timer", comment: "Quick timer section title"),
                systemImage: "timer"
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Constants.timerPresets, id: \.self) { minutes in
                    PresetButton(
                        minutes: minutes,
                        isLastUsed: minutes == viewModel.lastPresetMinutes
                    ) {
                        viewModel.startPreset(minutes: minutes)
                    }
                }
            }
        }
    }
}

// MARK: - Preset Button

private struct PresetButton: View {
    let minutes: Int
    let isLastUsed: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(minutes)")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                    .monospacedDigit()
                
                Text("min")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isLastUsed ? Color.accentColor.opacity(0.15) : (isHovered ? Color.primary.opacity(0.1) : Color.primary.opacity(0.05)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(isLastUsed ? Color.accentColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
