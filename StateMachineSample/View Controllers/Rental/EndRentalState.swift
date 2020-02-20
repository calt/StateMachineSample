import Foundation
import GameKit

final class EndRentalState: GKState, RentalState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        print("End Rental State")

        self.applyUpdates(
            .rentalStatusText(text: "Rental Ended. Duration: XX minutes"),
            .buttonTitle(title: "...")
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.rentalStateMachine.enter(RentalPreperationState.self)
        }
    }

    func handle(_ action: RentalUserAction) { }
}
