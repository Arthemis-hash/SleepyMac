import SwiftUI

struct CountdownTimerView: View {
    @ObservedObject var viewModel: CountdownTimerViewModel
    @AppStorage("soundEnabled") private var soundEnabled = false
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isRunning {
                activeCountdown
            } else {
                durationSelection
            }
        }
        .padding()
    }
    
    private var activeCountdown: some View {
        VStack(spacing: 16) {
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
                    
                    Text(viewModel.isPaused ? "paused" : "remaining")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                }
            }
            .frame(width: 150, height: 150)
            
            HStack(spacing: 12) {
                if viewModel.isPaused {
                    Button(action: {
                        viewModel.resume()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Resume", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(FluoButtonStyle(color: .greenFluo))
                } else {
                    Button(action: {
                        viewModel.pause()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Pause", systemImage: "pause.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(FluoButtonStyle(color: .orangeFluo))
                }
                
                Button(action: {
                    viewModel.cancel()
                    if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                }) {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(FluoButtonStyle(color: .red))
            }
        }
    }
    
    private var durationSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Countdown", systemImage: "hourglass")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach([1, 3, 5, 10, 15, 30], id: \.self) { minutes in
                    Button(action: {
                        viewModel.start(minutes: minutes)
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Text("\(minutes) min")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.primary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            HStack {
                TextField("Min", value: $viewModel.customMinutes, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                
                Spacer()
                
                Button(action: {
                    if viewModel.customMinutes > 0 {
                        viewModel.start(minutes: viewModel.customMinutes)
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }
                }) {
                    Label("Start", systemImage: "play.fill")
                }
                .buttonStyle(FluoButtonStyle(color: .orangeFluo))
                .disabled(viewModel.customMinutes <= 0)
            }
        }
    }
    
    private var timerColor: Color {
        if viewModel.secondsRemaining <= 10 {
            return .red
        } else if viewModel.secondsRemaining <= 30 {
            return .orange
        } else {
            return .orangeFluo
        }
    }
}
