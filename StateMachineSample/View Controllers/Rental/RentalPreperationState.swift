import Foundation
import GameKit

final class RentalPreperationState: GKState, RentalState {
    private let vehicleControlService: VehicleControlServiceType

    init(vehicleControlService: VehicleControlServiceType) {
        self.vehicleControlService = vehicleControlService
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        print("Rental Preparation State")

        applyUpdates(
            .rentalStatusText(text: "Ready for Rental"),
            .buttonTitle(title: "Unlock")
        )
    }

    func handle(_ action: RentalUserAction) {
        switch action {
        case .rentalButtonTap:
            unlockVehicle()
        }
    }

    private func unlockVehicle() {
        applyUpdates(
            .rentalStatusText(text: "Starting Rental"),
            .buttonTitle(title: "Unlocking...")
        )

        vehicleControlService.unlockVehicle { result in
            switch result {
                case .success(let text):
                    self.applyUpdate(.rentalStatusText(text: text))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.rentalStateMachine.enter(RideState.self)
                    }
                case .failure:
                    self.applyUpdates(
                        .rentalStatusText(text: "Starting Rental Failed"),
                        .buttonTitle(title: "Retry")
                    )
            }
        }
    }
}
