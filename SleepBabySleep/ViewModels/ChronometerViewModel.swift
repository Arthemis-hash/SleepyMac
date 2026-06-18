import SwiftUI
import Combine

@MainActor
final class ChronometerViewModel: ObservableObject {
    
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var isStopped: Bool = false
    @Published var laps: [TimeInterval] = []
    @Published private(set) var formattedTime: String = "00.00"
    
    private var timerCancellable: AnyCancellable?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    
    private static let maxLaps = 50
    
    /// True when timer has elapsed time but is not running (after pause+stop or reset)
    var canResume: Bool { isStopped && accumulatedTime > 0 }
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        isPaused = false
        isStopped = false
        startDate = Date()
        
        timerCancellable = Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func pause() {
        guard isRunning, !isPaused else { return }
        
        isPaused = true
        timerCancellable?.cancel()
        timerCancellable = nil
        
        if let start = startDate {
            accumulatedTime += Date().timeIntervalSince(start)
            startDate = nil
        }
        elapsedSeconds = accumulatedTime
        formattedTime = formatTime(accumulatedTime)
    }
    
    func resume() {
        guard isRunning, isPaused else { return }
        
        isPaused = false
        startDate = Date()
        
        timerCancellable = Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    /// Stop the timer but keep elapsed time in memory (for "Reprendre" feature)
    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
        
        if let start = startDate {
            accumulatedTime += Date().timeIntervalSince(start)
            startDate = nil
        }
        
        isRunning = false
        isPaused = false
        isStopped = true
        elapsedSeconds = accumulatedTime
        formattedTime = formatTime(accumulatedTime)
    }
    
    /// Resume from a stopped state (reprendre après reset)
    func resumeFromStop() {
        guard isStopped, accumulatedTime > 0 else { return }
        
        isRunning = true
        isPaused = false
        isStopped = false
        startDate = Date()
        
        timerCancellable = Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    /// Full reset — clears everything
    func reset() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
        isPaused = false
        isStopped = false
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
        
        // Memory optimization: cap laps to prevent unbounded growth
        if laps.count > Self.maxLaps {
            laps.removeFirst(laps.count - Self.maxLaps)
        }
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
        let hours = totalMs / 360000
        let minutes = (totalMs / 6000) % 60
        let secs = (totalMs / 100) % 60
        let centiseconds = totalMs % 100
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d.%02d", hours, minutes, secs, centiseconds)
        } else if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, secs, centiseconds)
        } else {
            return String(format: "%02d.%02d", secs, centiseconds)
        }
    }
    
    var formattedLaps: [String] {
        laps.map { formatTime($0) }
    }
}
