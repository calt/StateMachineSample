import Foundation
import GameKit

final class RideState: GKState, RentalState {
    private let vehicleControlService: VehicleControlServiceType

    init(vehicleControlService: VehicleControlServiceType) {
        self.vehicleControlService = vehicleControlService
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        print("Ride State")

        applyUpdates(
            .rentalStatusText(text: "Rental Active"),
            .buttonTitle(title: "Park")
        )
    }

    func handle(_ action: RentalUserAction) {
        switch action {
        case .rentalButtonTap:
            lockVehicle()
        }
    }

    private func lockVehicle() {
        applyUpdates(
            .rentalStatusText(text: "Parking Vehicle"),
            .buttonTitle(title: "Locking...")
        )

        vehicleControlService.lockVehicle { result in
            switch result {
                case .success(let text):
                    self.applyUpdate(.rentalStatusText(text: text))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.rentalStateMachine.enter(ParkState.self)
                    }
                case .failure:
                    self.applyUpdates(
                        .rentalStatusText(text: "Locking Failed"),
                        .buttonTitle(title: "Retry")
                    )
            }
        }
    }
}
