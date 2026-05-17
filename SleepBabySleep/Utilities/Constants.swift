import Foundation

/// App-wide constants
enum Constants {
    /// Available timer presets in minutes
    static let timerPresets: [Int] = [10, 15, 30, 45]
    
    /// Seconds before sleep to show warning notification
    static let warningBeforeSleepSeconds: TimeInterval = 30
    
    /// UserDefaults keys
    enum UserDefaultsKeys {
        static let lastPresetMinutes = "lastPresetMinutes"
        static let lastMode = "lastMode" // "preset" or "datetime"
        static let launchAtLogin = "launchAtLogin"
    }
    
    /// Bundle identifier
    static let bundleIdentifier = "com.sleepbabysleep.app"
    
    /// App name
    static let appName = "Sleep Baby Sleep"
}
