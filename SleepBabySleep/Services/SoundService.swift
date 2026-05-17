import SwiftUI
import AVFoundation

/// Service for playing system sounds
final class SoundService {
    
    static let shared = SoundService()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    /// Play a notification sound
    /// - Parameter soundName: Name of the sound ("glass", "bell", "chime", "pop")
    func play(soundName: String = "glass") {
        guard let url = soundURL(for: soundName) else {
            // Fallback to system sound
            NSSound.beep()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            NSSound.beep()
        }
    }
    
    /// Play the sleep warning sound (softer)
    func playWarning() {
        guard let url = soundURL(for: "Tink") else {
            NSSound.beep()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            NSSound.beep()
        }
    }
    
    /// Get URL for a system sound
    private func soundURL(for name: String) -> URL? {
        // System sounds are in /System/Library/Sounds/
        let systemPath = "/System/Library/Sounds/\(name).aiff"
        if FileManager.default.fileExists(atPath: systemPath) {
            return URL(fileURLWithPath: systemPath)
        }
        return nil
    }
    
    /// Stop any currently playing sound
    func stop() {
        audioPlayer?.stop()
    }
}
