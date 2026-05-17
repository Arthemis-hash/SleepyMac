import Foundation
import IOKit
import IOKit.pwr_mgt

/// Protocol for mocking in tests
protocol SleepServiceProtocol {
    func sleepNow() -> Bool
}

/// Service responsible for putting the Mac to sleep
/// Uses IOPMSleepSystem (native IOKit) as primary method,
/// falls back to pmset sleepnow via Process if IOKit fails.
final class SleepService: SleepServiceProtocol {
    
    /// Put the Mac to sleep immediately
    /// - Returns: true if the sleep command was accepted
    func sleepNow() -> Bool {
        if sleepViaIOKit() {
            return true
        }
        // Fallback to pmset
        return sleepViaPmset()
    }
    
    // MARK: - Private Methods
    
    /// Primary method: IOKit IOPMSleepSystem
    /// Works for the console user without sudo.
    private func sleepViaIOKit() -> Bool {
        let port = IOPMFindPowerManagement(mach_port_t(MACH_PORT_NULL))
        guard port != mach_port_t(MACH_PORT_NULL) else {
            return false
        }
        let result = IOPMSleepSystem(port)
        IOServiceClose(port)
        return result == kIOReturnSuccess
    }
    
    /// Fallback method: pmset sleepnow via Process
    /// Works for non-sandboxed apps without sudo.
    private func sleepViaPmset() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = ["sleepnow"]
        // Silence stdout/stderr
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
}
