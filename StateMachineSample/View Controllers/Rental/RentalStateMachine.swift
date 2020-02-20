import Foundation
import GameKit

enum RentalUserAction {
    case rentalButtonTap
}

enum RentalUIUpdate {
    case rentalStatusText(text: String)
    case buttonTitle(title: String)
}

protocol RentalUIUpdateHandlerType: class {
    func apply(_ update: RentalUIUpdate)
}

protocol RentalUserActionHandlerType: class {
    func handle(_ action: RentalUserAction)
}

protocol RentalStateMachineType: GKStateMachine, RentalUserActionHandlerType {
    var updateHandler: RentalUIUpdateHandlerType? { get set }
    func activate()
}

protocol RentalState: GKState, RentalUserActionHandlerType { }

extension RentalState {
    var rentalStateMachine: RentalStateMachineType {
        return stateMachine as! RentalStateMachineType
    }

    func applyUpdate(_ update: RentalUIUpdate) {
        rentalStateMachine.updateHandler?.apply(update)
    }

    func applyUpdates(_ updates: RentalUIUpdate...) {
        updates.forEach(applyUpdate)
    }
}


final class RentalStateMachine: GKStateMachine, RentalStateMachineType {
    private let vehicleControlService: VehicleControlServiceType

    weak var updateHandler: RentalUIUpdateHandlerType?

    init(vehicleControlService: VehicleControlServiceType) {
        self.vehicleControlService = vehicleControlService
        super.init(states: [
            RentalPreperationState(vehicleControlService: vehicleControlService),
            RideState(vehicleControlService: vehicleControlService),
            ParkState(),
            EndRentalState()
        ])
    }

    func activate() {
        guard currentState == nil else {
            assertionFailure("State machine already active")
            return
        }
        enter(RentalPreperationState.self)
    }
}

extension RentalStateMachine: RentalUserActionHandlerType {
    func handle(_ action: RentalUserAction) {
        (currentState as? RentalUserActionHandlerType)?.handle(action)
    }
}
