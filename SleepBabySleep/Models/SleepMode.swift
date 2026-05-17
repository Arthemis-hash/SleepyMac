import Foundation

/// Represents the two ways a user can schedule sleep
enum SleepMode: Equatable {
    case preset(minutes: Int)
    case dateTime(Date)

    var totalSeconds: TimeInterval {
        switch self {
        case .preset(let minutes):
            return TimeInterval(minutes * 60)
        case .dateTime(let date):
            return max(0, date.timeIntervalSinceNow)
        }
    }

    var label: String {
        switch self {
        case .preset(let minutes):
            return "\(minutes) min"
        case .dateTime(let date):
            return Self.timeFormatter.string(from: date)
        }
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()
}
