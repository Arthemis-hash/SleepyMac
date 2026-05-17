import SwiftUI

/// Stopwatch view with start/stop/reset/lap
struct ChronometerView: View {
    @StateObject private var viewModel = ChronometerViewModel()
    @AppStorage("soundEnabled") private var soundEnabled = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Time display
            Text(viewModel.formattedTime)
                .font(.system(size: 42, weight: .light, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(viewModel.isRunning ? Color.accentColor : .primary)
                .frame(height: 60)
            
            // Controls
            HStack(spacing: 16) {
                if viewModel.isRunning {
                    Button(action: {
                        viewModel.stop()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Button(action: {
                        viewModel.lap()
                        if soundEnabled { SoundService.shared.play(soundName: "Tink") }
                    }) {
                        Label("Lap", systemImage: "flag.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                } else {
                    Button(action: {
                        if viewModel.elapsedSeconds > 0 {
                            viewModel.reset()
                        } else {
                            viewModel.start()
                        }
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label(
                            viewModel.elapsedSeconds > 0 ? "Reset" : "Start",
                            systemImage: viewModel.elapsedSeconds > 0 ? "arrow.counterclockwise" : "play.fill"
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(viewModel.elapsedSeconds > 0 ? .secondary : .green)
                }
            }
            
            // Laps
            if !viewModel.laps.isEmpty {
                Divider()
                
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(Array(viewModel.formattedLaps.enumerated()), id: \.offset) { index, lapTime in
                            HStack {
                                Text("Lap \(index + 1)")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text(lapTime)
                                    .font(.system(.caption, design: .monospaced))
                                    .monospacedDigit()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.primary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        }
                    }
                }
                .frame(maxHeight: 100)
            }
        }
        .padding()
    }
}
