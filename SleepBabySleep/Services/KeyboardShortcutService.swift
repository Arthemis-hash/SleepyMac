import Foundation
import Cocoa

/// Service for handling global keyboard shortcuts
/// Cmd+Shift+Escape to cancel the active timer
final class KeyboardShortcutService {
    
    /// Callback when the cancel shortcut is pressed
    var onCancelShortcut: (() -> Void)?
    
    /// Monitor reference for cleanup
    private var globalMonitor: Any?
    private var localMonitor: Any?
    
    /// Start listening for global keyboard shortcuts
    func start() {
        // Global monitor (when app is not focused)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        
        // Local monitor (when app is focused)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
    }
    
    /// Stop listening for keyboard shortcuts
    func stop() {
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
            self.globalMonitor = nil
        }
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
            self.localMonitor = nil
        }
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Private
    
    /// Handle a key event, checking for Cmd+Shift+Escape
    private func handleKeyEvent(_ event: NSEvent) {
        // Check for Cmd+Shift+Escape (keyCode 53 = Escape)
        let requiredFlags: NSEvent.ModifierFlags = [.command, .shift]
        guard event.keyCode == 53,
              event.modifierFlags.contains(requiredFlags) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.onCancelShortcut?()
        }
    }
}
