import XCTest
@testable import SleepBabySleep

final class SleepTimerViewModelTests: XCTestCase {
    
    private var viewModel: SleepTimerViewModel!
    private var mockSleepService: MockSleepService!
    
    override func setUp() {
        super.setUp()
        mockSleepService = MockSleepService()
        viewModel = SleepTimerViewModel(sleepService: mockSleepService)
    }
    
    override func tearDown() {
        viewModel.cancel()
        viewModel = nil
        mockSleepService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isActive)
        XCTAssertEqual(viewModel.secondsRemaining, 0)
        XCTAssertNil(viewModel.currentMode)
        XCTAssertFalse(viewModel.warningSent)
    }
    
    // MARK: - Preset Timer
    
    func testStartPreset() {
        viewModel.startPreset(minutes: 10)
        
        XCTAssertTrue(viewModel.isActive)
        XCTAssertNotNil(viewModel.currentMode)
        XCTAssertEqual(viewModel.lastPresetMinutes, 10)
        
        // Should be approximately 600 seconds (10 minutes)
        XCTAssertEqual(viewModel.secondsRemaining, 600, accuracy: 2)
    }
    
    func testStartPresetSavesLastUsed() {
        viewModel.startPreset(minutes: 45)
        XCTAssertEqual(viewModel.lastPresetMinutes, 45)
        
        viewModel.cancel()
        viewModel.startPreset(minutes: 15)
        XCTAssertEqual(viewModel.lastPresetMinutes, 15)
    }
    
    // MARK: - DateTime Timer
    
    func testStartDateTime() {
        let futureDate = Date().addingTimeInterval(300) // 5 minutes from now
        viewModel.startDateTime(date: futureDate)
        
        XCTAssertTrue(viewModel.isActive)
        XCTAssertNotNil(viewModel.currentMode)
        XCTAssertEqual(viewModel.secondsRemaining, 300, accuracy: 2)
    }
    
    func testStartDateTimeInPastDoesNothing() {
        let pastDate = Date().addingTimeInterval(-60) // 1 minute ago
        viewModel.startDateTime(date: pastDate)
        
        XCTAssertFalse(viewModel.isActive)
        XCTAssertNil(viewModel.currentMode)
    }
    
    // MARK: - Cancel
    
    func testCancel() {
        viewModel.startPreset(minutes: 30)
        XCTAssertTrue(viewModel.isActive)
        
        viewModel.cancel()
        
        XCTAssertFalse(viewModel.isActive)
        XCTAssertEqual(viewModel.secondsRemaining, 0)
        XCTAssertNil(viewModel.currentMode)
        XCTAssertFalse(viewModel.warningSent)
    }
    
    func testCancelWhenNotActiveDoesNotCrash() {
        XCTAssertFalse(viewModel.isActive)
        viewModel.cancel() // Should not crash
        XCTAssertFalse(viewModel.isActive)
    }
    
    // MARK: - Starting New Timer Cancels Previous
    
    func testStartingNewTimerCancelsPrevious() {
        viewModel.startPreset(minutes: 10)
        XCTAssertTrue(viewModel.isActive)
        XCTAssertEqual(viewModel.secondsRemaining, 600, accuracy: 2)
        
        viewModel.startPreset(minutes: 45)
        XCTAssertTrue(viewModel.isActive)
        XCTAssertEqual(viewModel.secondsRemaining, 2700, accuracy: 2)
    }
    
    // MARK: - Progress
    
    func testProgressInitiallyZero() {
        XCTAssertEqual(viewModel.progress, 0)
    }
    
    // MARK: - Formatting
    
    func testTimeRemainingFormattedWhenInactive() {
        XCTAssertEqual(viewModel.timeRemainingFormatted, "00:00")
    }
    
    func testTimeRemainingFormattedWhenActive() {
        viewModel.startPreset(minutes: 10)
        // Should be something like "10:00" or "09:59"
        let formatted = viewModel.timeRemainingFormatted
        XCTAssertFalse(formatted.isEmpty)
    }
}

// MARK: - Mock Sleep Service

final class MockSleepService: SleepServiceProtocol {
    var sleepNowCalled = false
    var sleepNowResult = true
    
    func sleepNow() -> Bool {
        sleepNowCalled = true
        return sleepNowResult
    }
}
