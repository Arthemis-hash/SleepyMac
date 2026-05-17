import XCTest
@testable import SleepBabySleep

final class FormatterTests: XCTestCase {
    
    // MARK: - formatCountdown
    
    func testFormatCountdownZero() {
        XCTAssertEqual(Formatters.formatCountdown(0), "00:00")
    }
    
    func testFormatCountdownSeconds() {
        XCTAssertEqual(Formatters.formatCountdown(45), "00:45")
    }
    
    func testFormatCountdownMinutesAndSeconds() {
        XCTAssertEqual(Formatters.formatCountdown(125), "02:05")
    }
    
    func testFormatCountdownHours() {
        XCTAssertEqual(Formatters.formatCountdown(3661), "1:01:01")
    }
    
    func testFormatCountdownNegative() {
        XCTAssertEqual(Formatters.formatCountdown(-10), "00:00")
    }
    
    func testFormatCountdownExactMinute() {
        XCTAssertEqual(Formatters.formatCountdown(600), "10:00")
    }
    
    // MARK: - formatHumanReadable
    
    func testHumanReadableZero() {
        XCTAssertEqual(Formatters.formatHumanReadable(0), "0s")
    }
    
    func testHumanReadableSeconds() {
        XCTAssertEqual(Formatters.formatHumanReadable(45), "0m 45s")
    }
    
    func testHumanReadableMinutes() {
        XCTAssertEqual(Formatters.formatHumanReadable(600), "10m 0s")
    }
    
    func testHumanReadableHours() {
        XCTAssertEqual(Formatters.formatHumanReadable(3661), "1h 1m")
    }
    
    func testHumanReadableNegative() {
        XCTAssertEqual(Formatters.formatHumanReadable(-100), "0s")
    }
    
    // MARK: - formatMenuBar
    
    func testMenuBarZero() {
        XCTAssertEqual(Formatters.formatMenuBar(0), "0:00")
    }
    
    func testMenuBarExactMinutes() {
        XCTAssertEqual(Formatters.formatMenuBar(1800), "30m")
    }
    
    func testMenuBarMinutesAndSeconds() {
        XCTAssertEqual(Formatters.formatMenuBar(125), "2:05")
    }
    
    func testMenuBarHours() {
        XCTAssertEqual(Formatters.formatMenuBar(3661), "1:01")
    }
}
