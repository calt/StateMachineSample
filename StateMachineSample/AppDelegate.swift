import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // This simulates different vehicle types selected for a rental
        let coinFlip = Bool.random()
        let controlService: VehicleControlServiceType
            = coinFlip ? BluetoothVehicleControlService()
                       : CloudboxxVehicleControlService()

        let rentalStateMachine = RentalStateMachine(vehicleControlService: controlService)
        let rentalViewController = RentalViewController(stateMachine: rentalStateMachine)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rentalViewController
        window?.makeKeyAndVisible()

        return true
    }
}

