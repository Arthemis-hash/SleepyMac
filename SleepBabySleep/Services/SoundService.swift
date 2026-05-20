import SwiftUI
import AVFoundation

final class SoundService {
    
    static let shared = SoundService()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func play(soundName: String = "glass") {
        guard let url = soundURL(for: soundName) else {
            NSSound.beep()
            return
        }
        
        do {
            // Memory fix: stop and release old player before creating new one
            audioPlayer?.stop()
            audioPlayer = nil
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            NSSound.beep()
        }
    }
    
    private func soundURL(for name: String) -> URL? {
        let systemPath = "/System/Library/Sounds/\(name).aiff"
        if FileManager.default.fileExists(atPath: systemPath) {
            return URL(fileURLWithPath: systemPath)
        }
        return nil
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
