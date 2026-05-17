import Foundation
import Combine

/// ViewModel for the stopwatch (chronometer)
final class ChronometerViewModel: ObservableObject {
    
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var laps: [TimeInterval] = []
    
    var formattedTime: String {
        let totalMs = Int(elapsedSeconds * 100)
        let minutes = (totalMs / 6000) % 60
        let seconds = (totalMs / 100) % 60
        let centiseconds = totalMs % 100
        
        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, seconds, centiseconds)
        } else {
            return String(format: "%02d.%02d", seconds, centiseconds)
        }
    }
    
    var formattedLaps: [String] {
        laps.map { time in
            let totalMs = Int(time * 100)
            let minutes = (totalMs / 6000) % 60
            let seconds = (totalMs / 100) % 60
            let centiseconds = totalMs % 100
            return String(format: "%d:%02d.%02d", minutes, seconds, centiseconds)
        }
    }
    
    private var timerCancellable: AnyCancellable?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        startDate = Date()
        
        timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common)
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
    }
    
    func lap() {
        guard isRunning else { return }
        
        let currentTime = accumulatedTime + (startDate.map { Date().timeIntervalSince($0) } ?? 0)
        laps.append(currentTime)
    }
    
    private func tick() {
        if let start = startDate {
            elapsedSeconds = accumulatedTime + Date().timeIntervalSince(start)
        }
    }
}
