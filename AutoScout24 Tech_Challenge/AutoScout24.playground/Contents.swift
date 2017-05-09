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


class LocalPersistence : Retrievable,Updateable {
    func updateCar(car: Car) -> Car? {
        return nil
    }

    func retriveCars() -> [Car]? {
        return nil
    }
    
    func insertCar(car: Car) {
        
    }
}


class RemotePersistence : Retrievable,Updateable{
    
    func retriveCars() -> [Car]? {
        return nil
    }
    
    func updateCar(car: Car) -> Car? {
        return nil
    }
}


protocol Coordinatable {
    func listCars(retrievables: Retrievable..., onSuccess: ([Car]) -> Void)
    func updateCar(updateables : Updateable...) -> Car?
}

class DataCoordinator : Coordinatable{
    
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

final class PersistenceLayer {
    static let shared = PersistenceLayer()
    
    private var localDataInteractor = LocalPersistence()
    private var remoteDataInteractor = RemotePersistence()
    
    private var coordinator = DataCoordinator()
    
    func getData(onSuccess: (([Car]) -> Void)) {
        coordinator.listCars(retrievables: localDataInteractor,remoteDataInteractor) { (cars) in
            onSuccess(cars)
        }
    }
    
    func updateCar(car : Car) {
        coordinator.updateCar(updateables: localDataInteractor)
    }
}

PersistenceLayer.shared.getData { (cars) in
    print(cars.count)
}
var car = Car()

PersistenceLayer.shared.updateCar(car: car)
