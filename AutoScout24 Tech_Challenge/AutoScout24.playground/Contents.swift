//: Playground - noun: a place where people can play

import UIKit

print("Hello AutoScout24! ")

class Car {
    var id: Int?
    var AccidentFree: Bool?
    var Mileage: Int?
    var Make: String?
}

protocol Retrievable {
    func retriveCars() -> [Car]?
}

protocol Updateable{
    func updateCar(car: Car) -> Car?
}

protocol Coordinatable {
    func listCars(retrievables: Retrievable..., onSuccess: ([Car]) -> Void)
    func updateCar(updateables : Updateable...) -> Car?
}


class LocalDataCoordinator : Coordinatable{
    static let shared = LocalDataCoordinator()
    
    func listCars(retrievables: Retrievable..., onSuccess: ([Car]) -> Void) {
        
    }
    
    func create(car: Car) {
        
    }
    
    func updateCar(updateables: Updateable...) -> Car? {
        return nil
    }
}

class RemoteDataCoordinator : Coordinatable{
    
    func listCars(retrievables: Retrievable..., onSuccess: ([Car]) -> Void) {
        if let localDataRetrievable = retrievables.first{
            localDataRetrievable.retriveCars()
            
        }
        if let remoteDataRetrievable = retrievables.last{
            remoteDataRetrievable.retriveCars()
        }
        onSuccess([])
    }
    
    func updateCar(updateables: Updateable...) -> Car? {
        return nil
    }
}
