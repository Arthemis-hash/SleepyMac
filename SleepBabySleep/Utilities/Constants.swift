import Foundation

extension Notification.Name {
    static let cancelAllTimers = Notification.Name("cancelAllTimers")
}

enum Constants {
    static let timerPresets: [Int] = [10, 15, 30, 45]
    static let warningBeforeSleepSeconds: TimeInterval = 30
    
    enum UserDefaultsKeys {
        static let lastPresetMinutes = "lastPresetMinutes"
        static let launchAtLogin = "launchAtLogin"
        static let soundEnabled = "soundEnabled"
    }
    
    static let bundleIdentifier = "com.sleepmac.app"
    static let appName = "SleepMac"
}
