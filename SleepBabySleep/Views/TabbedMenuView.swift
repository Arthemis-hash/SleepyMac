import SwiftUI
import ServiceManagement

struct TabbedMenuView: View {
    @State private var selectedTab: AppTab = .sleep
    @StateObject private var sleepViewModel = SleepTimerViewModel()
    
    enum AppTab: String, CaseIterable {
        case chrono = "Chrono"
        case countdown = "Countdown"
        case sleep = "Sleep"
        
        var icon: String {
            switch self {
            case .chrono: return "stopwatch"
            case .countdown: return "hourglass"
            case .sleep: return "moon.zzz"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            tabBar
            
            Divider()
            
            tabContent
            
            Divider()
            
            footerSection
        }
        .frame(width: 300)
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                TabButton(tab: tab, isSelected: selectedTab == tab) {
                    withAnimation(.spring(response: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .background(Color.primary.opacity(0.03))
    }
    
    private var tabContent: some View {
        Group {
            switch selectedTab {
            case .chrono:
                ChronometerView()
            case .countdown:
                CountdownTimerView()
            case .sleep:
                SleepTimerView(viewModel: sleepViewModel)
            }
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 6) {
            HStack {
                Toggle(isOn: soundBinding) {
                    Label("Sound", systemImage: "speaker.wave.2")
                        .font(.system(.caption, design: .rounded))
                }
                .toggleStyle(.switch)
                .controlSize(.mini)
                
                Spacer()
                
                Toggle(isOn: loginBinding) {
                    Label("Auto-start", systemImage: "power")
                        .font(.system(.caption, design: .rounded))
                }
                .toggleStyle(.switch)
                .controlSize(.mini)
            }
            .padding(.horizontal)
            
            Text("Cmd+Shift+Esc to cancel")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.tertiary)
            
            Divider()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Label("Quit", systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
        .padding(.bottom, 6)
    }
    
    private var soundBinding: Binding<Bool> {
        Binding(
            get: { UserDefaults.standard.bool(forKey: "soundEnabled") },
            set: { UserDefaults.standard.set($0, forKey: "soundEnabled") }
        )
    }
    
    private var loginBinding: Binding<Bool> {
        Binding(
            get: { UserDefaults.standard.bool(forKey: "launchAtLogin") },
            set: { updateLoginItem(enabled: $0) }
        )
    }
    
    private func updateLoginItem(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "launchAtLogin")
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Login item error: \(error.localizedDescription)")
            }
        }
    }
}

private struct TabButton: View {
    let tab: TabbedMenuView.AppTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: tab.icon)
                    .font(.system(size: 14))
                Text(tab.rawValue)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? Color.accentColor : .secondary)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}
