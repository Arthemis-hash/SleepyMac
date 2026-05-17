import SwiftUI

/// Main popup view displayed when clicking the menu bar icon
struct MenuContentView: View {
    @ObservedObject var viewModel: SleepTimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            Divider()
                .padding(.horizontal)
            
            if viewModel.isActive {
                // Active timer view
                CountdownView(viewModel: viewModel)
                    .padding()
            } else {
                // Timer selection
                VStack(spacing: 16) {
                    TimerPresetsView(viewModel: viewModel)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    DateTimePickerView(viewModel: viewModel)
                }
                .padding()
            }
            
            Divider()
                .padding(.horizontal)
            
            // Footer
            footerSection
        }
        .frame(width: 320)
        .padding(.vertical, 4)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            Image(systemName: "moon.zzz.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.indigo, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .purple.opacity(0.3), radius: 2, x: 0, y: 1)
            
            Text(NSLocalizedString("app.title", value: "Sleep Baby Sleep", comment: "App title"))
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
            
            Spacer()
            
            if viewModel.isActive {
                statusBadge
            }
        }
        .padding()
    }
    
    private var statusBadge: some View {
        Text(NSLocalizedString("status.active", value: "Active", comment: "Timer active status"))
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(.green.opacity(0.2))
            .foregroundStyle(.green)
            .clipShape(Capsule())
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            // Launch at login toggle
            Toggle(isOn: $viewModel.launchAtLogin) {
                Label(
                    NSLocalizedString("settings.launchAtLogin", value: "Launch at Login", comment: "Launch at login toggle"),
                    systemImage: "arrow.right.circle"
                )
                .font(.caption)
            }
            .toggleStyle(.switch)
            .controlSize(.mini)
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Shortcut hint
            Text(NSLocalizedString("shortcut.hint", value: "Cmd+Shift+Esc to cancel", comment: "Keyboard shortcut hint"))
                .font(.caption2)
                .foregroundStyle(.tertiary)
            
            Divider()
            
            // Quit button
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Label(
                    NSLocalizedString("action.quit", value: "Quit", comment: "Quit button"),
                    systemImage: "xmark.circle"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
}
