import Foundation
import GameKit

final class ParkState: GKState, RentalState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        print("Park State")

        self.applyUpdates(
            .rentalStatusText(text: "Vehicle Parked"),
            .buttonTitle(title: "End Rental")
        )
    }

    func handle(_ action: RentalUserAction) {
        switch action {
        case .rentalButtonTap:
            endRental()
        }
    }

    private func endRental() {
        self.applyUpdates(
            .rentalStatusText(text: "Ending Rental"),
            .buttonTitle(title: "...")
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.rentalStateMachine.enter(EndRentalState.self)
        }
    }

}
