import Foundation

class CloudboxxVehicleControlService: VehicleControlServiceType {
    func unlockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            callback(.success("Unlocked w/ Cloudboxx"))
        }
    }

    func lockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            callback(.success("Locked w/ Cloudboxx"))
        }
    }
}
