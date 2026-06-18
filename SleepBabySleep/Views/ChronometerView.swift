import SwiftUI

struct ChronometerView: View {
    @ObservedObject var viewModel: ChronometerViewModel
    @AppStorage("soundEnabled") private var soundEnabled = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.formattedTime)
                .font(.system(size: 42, weight: .light, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(viewModel.isRunning ? Color.orangeFluo : .primary)
                .frame(height: 60)
            
            HStack(spacing: 12) {
                if viewModel.isRunning {
                    if viewModel.isPaused {
                        Button(action: {
                            viewModel.resume()
                            if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                        }) {
                            Label("Resume", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(FluoButtonStyle(color: .greenFluo))
                    } else {
                        Button(action: {
                            viewModel.pause()
                            if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                        }) {
                            Label("Pause", systemImage: "pause.fill")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(FluoButtonStyle(color: .orangeFluo))
                    }
                    
                    Button(action: {
                        viewModel.stop()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(FluoButtonStyle(color: .secondary))
                    
                } else if viewModel.isStopped {
                    Button(action: {
                        viewModel.resumeFromStop()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Reprendre", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(FluoButtonStyle(color: .greenFluo))
                    
                    Button(action: {
                        viewModel.reset()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Effacer", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(FluoButtonStyle(color: .secondary))
                    
                } else {
                    Button(action: {
                        viewModel.start()
                        if soundEnabled { SoundService.shared.play(soundName: "Pop") }
                    }) {
                        Label("Start", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(FluoButtonStyle(color: .greenFluo))
                }
            }
            
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
