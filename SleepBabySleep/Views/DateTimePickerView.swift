import SwiftUI

/// Date and time picker for scheduling sleep at a specific time
struct DateTimePickerView: View {
    @ObservedObject var viewModel: SleepTimerViewModel
    
    /// Minimum selectable date: 1 minute from now
    private var minimumDate: Date {
        Date().addingTimeInterval(60)
    }
    
    /// Maximum selectable date: 24 hours from now
    private var maximumDate: Date {
        Date().addingTimeInterval(24 * 3600)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(
                NSLocalizedString("section.scheduleTime", value: "Schedule Time", comment: "Schedule time section title"),
                systemImage: "clock"
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            
            HStack {
                DatePicker(
                    "",
                    selection: $viewModel.selectedDate,
                    in: minimumDate...maximumDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .blendMode(.normal) // Ensures crisp rendering
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.startDateTime(date: viewModel.selectedDate)
                    }
                }) {
                    Label(
                        NSLocalizedString("action.schedule", value: "Start", comment: "Schedule button"),
                        systemImage: "play.fill"
                    )
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                .tint(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }
}
