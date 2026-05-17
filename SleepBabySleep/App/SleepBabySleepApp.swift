import SwiftUI

@main
struct SleepBabySleepApp: App {
    @StateObject private var viewModel = SleepTimerViewModel()
    
    var body: some Scene {
        MenuBarExtra {
            MenuContentView(viewModel: viewModel)
                .frame(width: 320)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: viewModel.isActive ? "moon.zzz.fill" : "moon.zzz")
                if viewModel.isActive {
                    Text(viewModel.timeRemainingFormatted)
                        .monospacedDigit()
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
