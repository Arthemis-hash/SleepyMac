import Foundation
import Combine
import UserNotifications
import ServiceManagement

final class SleepTimerViewModel: ObservableObject {

    @Published var isActive: Bool = false

    @Published var secondsRemaining: TimeInterval = 0

    @Published var currentMode: SleepMode?

    @Published var targetDate: Date = Date()

    @Published var selectedDate: Date = Date().addingTimeInterval(3600)

    @Published var lastPresetMinutes: Int = 30 {
        didSet {
            UserDefaults.standard.set(lastPresetMinutes, forKey: Constants.UserDefaultsKeys.lastPresetMinutes)
        }
    }

    @Published var launchAtLogin: Bool = false {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: Constants.UserDefaultsKeys.launchAtLogin)
            updateLoginItem()
        }
    }

    @Published var warningSent: Bool = false

    var timeRemainingFormatted: String {
        Formatters.formatCountdown(secondsRemaining)
    }

    var progress: Double {
        guard let mode = currentMode else { return 0 }
        let total = mode.totalSeconds
        guard total > 0 else { return 0 }
        return max(0, min(1, 1 - (secondsRemaining / total)))
    }

    private var timerCancellable: AnyCancellable?
    private let sleepService: SleepServiceProtocol
    private let notificationService: NotificationService
    private let shortcutService: KeyboardShortcutService
    private var notificationDelegate: NotificationDelegate?

    init(sleepService: SleepServiceProtocol = SleepService(),
         notificationService: NotificationService = .shared) {
        self.sleepService = sleepService
        self.notificationService = notificationService
        self.shortcutService = KeyboardShortcutService()

        self.lastPresetMinutes = {
            let saved = UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeys.lastPresetMinutes)
            return saved == 0 ? 30 : saved
        }()
        self.launchAtLogin = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.launchAtLogin)

        notificationService.requestPermission()

        shortcutService.onCancelShortcut = { [weak self] in
            self?.cancel()
        }
        shortcutService.start()

        let delegate = NotificationDelegate { [weak self] in
            self?.cancel()
        }
        UNUserNotificationCenter.current().delegate = delegate
        self.notificationDelegate = delegate
    }

    func startPreset(minutes: Int) {
        lastPresetMinutes = minutes
        let mode = SleepMode.preset(minutes: minutes)
        startTimer(mode: mode, duration: TimeInterval(minutes * 60))
    }

    func startDateTime(date: Date) {
        let secondsUntil = date.timeIntervalSinceNow
        guard secondsUntil > 0 else { return }
        let mode = SleepMode.dateTime(date)
        startTimer(mode: mode, duration: secondsUntil)
    }

    func cancel() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isActive = false
        secondsRemaining = 0
        currentMode = nil
        warningSent = false
        notificationService.clearWarnings()
    }

    private func startTimer(mode: SleepMode, duration: TimeInterval) {
        cancel()

        currentMode = mode
        secondsRemaining = duration
        targetDate = Date().addingTimeInterval(duration)
        isActive = true
        warningSent = false

        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        secondsRemaining = max(0, targetDate.timeIntervalSinceNow)

        if secondsRemaining <= Constants.warningBeforeSleepSeconds && !warningSent && secondsRemaining > 0 {
            warningSent = true
            notificationService.sendSleepWarning()
        }

        if secondsRemaining <= 0 {
            triggerSleep()
        }
    }

    private func triggerSleep() {
        cancel()
        notificationService.clearWarnings()
        _ = sleepService.sleepNow()
    }

    private func updateLoginItem() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update login item: \(error.localizedDescription)")
            }
        }
    }
}
