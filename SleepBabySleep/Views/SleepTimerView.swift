import SwiftUI

struct SleepTimerView: View {
    @ObservedObject var viewModel: SleepTimerViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isActive {
                activeTimer
            } else {
                timerSelection
            }
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: .cancelAllTimers)) { _ in
            viewModel.cancel()
        }
    }
    
    private var activeTimer: some View {
        VStack(spacing: 16) {
            if let mode = viewModel.currentMode {
                Text(modeDescription(mode))
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.08), lineWidth: 8)
                
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
                
                VStack(spacing: 2) {
                    Text(viewModel.timeRemainingFormatted)
                        .font(.system(size: 34, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .shadow(color: timerColor.opacity(0.2), radius: 2, x: 0, y: 0)
                    
                    Text("until sleep")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                }
            }
            .frame(width: 150, height: 150)
            
            if viewModel.warningSent {
                Label("Sleeping soon...", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.orange)
                    .transition(.opacity)
            }
            
            Button(action: {
                viewModel.cancel()
                if UserDefaults.standard.bool(forKey: "soundEnabled") {
                    SoundService.shared.play(soundName: "Pop")
                }
            }) {
                Label("Cancel", systemImage: "xmark.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(FluoButtonStyle(color: .red))
        }
        .animation(.easeInOut, value: viewModel.warningSent)
    }
    
    private var timerSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Sleep Timer", systemImage: "moon.zzz.fill")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(Constants.timerPresets, id: \.self) { minutes in
                    Button(action: {
                        viewModel.startPreset(minutes: minutes)
                        if UserDefaults.standard.bool(forKey: "soundEnabled") {
                            SoundService.shared.play(soundName: "Pop")
                        }
                    }) {
                        Text("\(minutes) min")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11.5)
                            .background(
                                minutes == viewModel.lastPresetMinutes
                                    ? Color.orangeFluo.opacity(0.15)
                                    : Color.primary.opacity(0.05)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(
                                        minutes == viewModel.lastPresetMinutes
                                            ? Color.orangeFluo.opacity(0.4)
                                            : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Schedule")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                HStack {
                    DatePicker(
                        "",
                        selection: $viewModel.selectedDate,
                        in: Date().addingTimeInterval(60)...Date().addingTimeInterval(24 * 3600),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.startDateTime(date: viewModel.selectedDate)
                        if UserDefaults.standard.bool(forKey: "soundEnabled") {
                            SoundService.shared.play(soundName: "Pop")
                        }
                    }) {
                        Label("Start", systemImage: "play.fill")
                    }
                    .buttonStyle(FluoButtonStyle(color: .orangeFluo, isLarge: true))
                }
            }
        }
    }
    
    private var timerColor: Color {
        if viewModel.secondsRemaining <= 30 {
            return .red
        } else if viewModel.secondsRemaining <= 60 {
            return .orange
        } else {
            return .orangeFluo
        }
    }
    
    private func modeDescription(_ mode: SleepMode) -> String {
        switch mode {
        case .preset(let minutes):
            return "\(minutes) minute timer"
        case .dateTime(let date):
            return "Scheduled for \(Self.timeFormatter.string(from: date))"
        }
    }
    
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()
}
