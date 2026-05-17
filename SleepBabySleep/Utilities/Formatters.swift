import Foundation

/// Utilities for formatting time intervals
enum Formatters {
    /// Format seconds into "MM:SS" or "H:MM:SS"
    /// - Parameter seconds: Total seconds remaining
    /// - Returns: Formatted string like "12:34" or "1:23:45"
    static func formatCountdown(_ seconds: TimeInterval) -> String {
        let totalSeconds = Int(max(0, seconds))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
    
    /// Format seconds into a human-readable string like "1h 23m" or "45m 12s"
    /// - Parameter seconds: Total seconds remaining
    /// - Returns: Human-readable string
    static func formatHumanReadable(_ seconds: TimeInterval) -> String {
        let totalSeconds = Int(max(0, seconds))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m \(secs)s"
        } else {
            return "\(secs)s"
        }
    }
    
    /// Format for the menu bar (compact)
    /// - Parameter seconds: Total seconds remaining
    /// - Returns: Compact string like "45m" or "1:23"
    static func formatMenuBar(_ seconds: TimeInterval) -> String {
        let totalSeconds = Int(max(0, seconds))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d", hours, minutes)
        } else if minutes > 0 && secs == 0 {
            return "\(minutes)m"
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }
}
