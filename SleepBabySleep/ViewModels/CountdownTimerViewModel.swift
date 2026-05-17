import Foundation
import Combine
import UserNotifications

/// ViewModel for countdown timer
final class CountdownTimerViewModel: ObservableObject {
    
    @Published var isRunning: Bool = false
    @Published var secondsRemaining: TimeInterval = 0
    @Published var customMinutes: Int = 0
    
    var timeRemainingFormatted: String {
        let totalSeconds = Int(max(0, secondsRemaining))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return max(0, min(1, 1 - (secondsRemaining / totalDuration)))
    }
    
    private var timerCancellable: AnyCancellable?
    private var targetDate: Date = Date()
    private var totalDuration: TimeInterval = 0
    
    func start(minutes: Int) {
        cancel()
        
        let duration = TimeInterval(minutes * 60)
        totalDuration = duration
        secondsRemaining = duration
        targetDate = Date().addingTimeInterval(duration)
        isRunning = true
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func cancel() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
        secondsRemaining = 0
        totalDuration = 0
    }
    
    private func tick() {
        secondsRemaining = max(0, targetDate.timeIntervalSinceNow)
        
        if secondsRemaining <= 0 {
            triggerDone()
        }
    }
    
    private func triggerDone() {
        cancel()
        
        // Send notification
        let content = UNMutableNotificationContent()
        content.title = "Countdown Finished"
        content.body = "Your timer has completed!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "countdown-done-\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
        
        // Play sound
        SoundService.shared.play(soundName: "Glass")
    }
}
