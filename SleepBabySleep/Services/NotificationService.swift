import Foundation
import UserNotifications

/// Service responsible for sending local notifications
/// before the Mac goes to sleep (30s warning).
final class NotificationService {
    
    static let shared = NotificationService()
    
    /// Notification category identifier for sleep warning
    private let categoryIdentifier = "SLEEP_WARNING"
    
    /// Action identifier for canceling sleep from notification
    static let cancelActionIdentifier = "CANCEL_SLEEP"
    
    private init() {
        setupCategories()
    }
    
    /// Request notification permissions from the user
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send a warning notification that sleep is coming in 30 seconds
    func sendSleepWarning() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification.warning.title", value: "Sleep Baby Sleep", comment: "Notification title")
        content.body = NSLocalizedString("notification.warning.body", value: "Your Mac will sleep in 30 seconds", comment: "Notification body warning")
        content.sound = .default
        content.categoryIdentifier = categoryIdentifier
        
        let request = UNNotificationRequest(
            identifier: "sleep-warning-\(UUID().uuidString)",
            content: content,
            trigger: nil // Deliver immediately
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Remove any pending sleep warning notifications
    func clearWarnings() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    // MARK: - Private
    
    /// Setup notification categories with Cancel action
    private func setupCategories() {
        let cancelAction = UNNotificationAction(
            identifier: Self.cancelActionIdentifier,
            title: NSLocalizedString("notification.action.cancel", value: "Cancel Sleep", comment: "Cancel sleep action button"),
            options: [.destructive, .foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: [cancelAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
