import SwiftUI
import Combine

@MainActor
final class ChronometerViewModel: ObservableObject {
    
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var laps: [TimeInterval] = []
    @Published private(set) var formattedTime: String = "00.00"
    
    private var timerCancellable: AnyCancellable?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        startDate = Date()
        
        timerCancellable = Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func stop() {
        guard isRunning else { return }
        
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
        
        if let start = startDate {
            accumulatedTime += Date().timeIntervalSince(start)
            startDate = nil
        }
    }
    
    func reset() {
        stop()
        elapsedSeconds = 0
        accumulatedTime = 0
        startDate = nil
        laps = []
        formattedTime = "00.00"
    }
    
    func lap() {
        guard isRunning else { return }
        
        let currentTime = accumulatedTime + (startDate.map { Date().timeIntervalSince($0) } ?? 0)
        laps.append(currentTime)
    }
    
    private func tick() {
        if let start = startDate {
            let newElapsed = accumulatedTime + Date().timeIntervalSince(start)
            elapsedSeconds = newElapsed
            formattedTime = formatTime(newElapsed)
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let totalMs = Int(seconds * 100)
        let minutes = (totalMs / 6000) % 60
        let secs = (totalMs / 100) % 60
        let centiseconds = totalMs % 100
        
        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, secs, centiseconds)
        } else {
            return String(format: "%02d.%02d", secs, centiseconds)
        }
    }
    
    var formattedLaps: [String] {
        laps.map { formatTime($0) }
    }
}
