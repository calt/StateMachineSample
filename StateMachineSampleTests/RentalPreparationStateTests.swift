import XCTest
import GameKit
@testable import StateMachineSample

class RentalPreparationStateTests: XCTestCase {

    private var mockUpdateHandler: MockUIUpdateHandler!
    private var mockVehicleControlService: MockVehicleControlService!

    override func setUp() {
        mockUpdateHandler = MockUIUpdateHandler()
        mockVehicleControlService = MockVehicleControlService()
    }

    func testRentalPreperationState() {
        let state = RentalPreperationState(vehicleControlService: mockVehicleControlService)
        let mockStateMachine = MockStateMachine(state: state)
        mockStateMachine.updateHandler = mockUpdateHandler
        mockStateMachine.expectation = self.expectation(description: "Should change state asyncronously")

        mockStateMachine.activate()

        state.handle(.rentalButtonTap)

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(mockUpdateHandler.triggeredUpdates.count, 3)

        // Swift doesn't automatically syntesize `==` method for enums with associated
        // values, we need to implemented seperately.
        // For demo purposes, I'm doing this the easier way.
        if case .rentalStatusText(let text) = mockUpdateHandler.triggeredUpdates[0] {
            XCTAssertEqual(text, "Starting Rental")
        } else {
            XCTFail("Triggered wrong update")
        }

        if case .buttonTitle(let title) = mockUpdateHandler.triggeredUpdates[1] {
            XCTAssertEqual(title, "Unlocking...")
        } else {
            XCTFail("Triggered wrong update")
        }

        if case .rentalStatusText(let text) = mockUpdateHandler.triggeredUpdates[2] {
            XCTAssertEqual(text, "RentalPreperatonState Unlock Success")
        } else {
            XCTFail("Triggered wrong update")
        }

        // Only the happy case is tested so far. We can change the flags on
        // the mock classes and test all possible scenarios.
    }
}

private class MockUIUpdateHandler: RentalUIUpdateHandlerType {
    var triggeredUpdates: [RentalUIUpdate] = []
    func apply(_ update: RentalUIUpdate) {
        triggeredUpdates.append(update)
    }
}

private class MockStateMachine<T: RentalState>: GKStateMachine, RentalStateMachineType {
    var updateHandler: RentalUIUpdateHandlerType?

    var testedState: T

    var expectation: XCTestExpectation?

    init(state: T) {
        testedState = state
        super.init(states: [
            state
        ])
    }

    func activate() {
        _ = enter(T.self)
    }

    override func enter(_ stateClass: AnyClass) -> Bool {
        expectation?.fulfill()
        return true
    }

    func handle(_ action: RentalUserAction) {
    }
}

private class MockVehicleControlService: VehicleControlServiceType {

    var shouldFail: Bool = false

    func unlockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void) {
        shouldFail ? callback(.failure(VehicleControlError.someOtherError))
                   : callback(.success("RentalPreperatonState Unlock Success"))
    }

    func lockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void) {
        shouldFail ? callback(.failure(VehicleControlError.someOtherError))
                   : callback(.success("RentalPreperatonState Lock Success"))
    }
}
