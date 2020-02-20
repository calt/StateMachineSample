import Foundation

enum VehicleControlError: Error {
    case connectionError
    case someOtherError
}

protocol VehicleControlServiceType {
    func unlockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void)
    func lockVehicle(callback: @escaping (Result<String, VehicleControlError>) -> Void)
}
