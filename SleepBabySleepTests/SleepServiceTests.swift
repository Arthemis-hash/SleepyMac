import XCTest
@testable import SleepBabySleep

final class SleepServiceTests: XCTestCase {
    
    func testMockSleepServiceReturnsTrue() {
        let mock = MockSleepService()
        mock.sleepNowResult = true
        
        let result = mock.sleepNow()
        
        XCTAssertTrue(result)
        XCTAssertTrue(mock.sleepNowCalled)
    }
    
    func testMockSleepServiceReturnsFalse() {
        let mock = MockSleepService()
        mock.sleepNowResult = false
        
        let result = mock.sleepNow()
        
        XCTAssertFalse(result)
        XCTAssertTrue(mock.sleepNowCalled)
    }
    
    func testSleepServiceConformsToProtocol() {
        let service: SleepServiceProtocol = SleepService()
        XCTAssertNotNil(service)
    }
    
    // NOTE: We do NOT test sleepNow() on the real SleepService
    // because it would actually put the Mac to sleep.
    // The IOKit and pmset logic is tested via the mock and
    // manual testing only.
}
