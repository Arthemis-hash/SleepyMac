import SwiftUI

@main
struct SleepMacApp: App {
    var body: some Scene {
        MenuBarExtra {
            TabbedMenuView()
        } label: {
            HStack(spacing: 3) {
                Image(systemName: "alarm.fill")
                Circle()
                    .fill(.red)
                    .frame(width: 5, height: 5)
                    .offset(x: -4, y: -4)
            }
        }
        .menuBarExtraStyle(.window)
    }
}
