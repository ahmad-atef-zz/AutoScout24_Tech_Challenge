//
//  DBInteractor.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/10/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation
import Alamofire
import CoreData



// Enum to Unify The Car Keys Object.

enum CarKey: String {
    case idKey = "ID",
    firstRegistrationKey = "FirstRegistration",
    accidentFreeKey = "AccidentFree",
    powerKWKey = "PowerKW",
    address = "Address",
    price = "Price",
    mileage = "Mileage",
    make = "Make",
    fuelType = "FuelType",
    images = "Images",
    responseKey = "vehicles",
    isFavorited = "isFavorited"
}

class DBIntercotr : SubjectBase{
    static let shared = DBIntercotr()
    
    override init() {
        super.init()
    }
    
    let context = CONTEXT
    
    
    // MARK: - Loading Data. -
    
    /// Load Local Cars saved in Core Data.
    ///
    /// - Parameter favoritesOnly: Optional flag to load only the Favorited Cars. Default value is False.
    /// - Returns: Returen List of Favorited Locally Saved Cars.
    func loadLocalCars(favoritesOnly : Bool = false) -> [Car] {
        var localCars : [Car] = []
        do{
            localCars = try context.fetch(Car.fetchRequest())
        }
        catch{
        }
        if favoritesOnly {
            localCars = localCars.filter({$0.isFavorited == true})
        }
        return localCars
    }
    
    
    /// Load Remote Cars from API.
    ///
    /// - Parameters:
    ///   - manufacturer: Filter the result by sending manufacturer Value, default Value is All.
    ///   - onSuccess: Success Block with List of Fitched Cars, when the Data Returned Successfully.
    ///   - onFail: failure Block with Error message to be Displayed in UI.
    func loadRemoteCars(manufacturer : String = "all", onSuccess:@escaping ([Car]) -> Void, onFail: @escaping (String) -> Void) {
        Alamofire.request(Router.listCars(parms: manufacturer))
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                
                guard response.result.isSuccess else{
                    let localCars = self.loadLocalCars()
                    onSuccess(localCars)
                    return
                }
                if let data = response.data {
                    do {
                        let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as![String:AnyObject]
                        if let vehicles = jsonDictionary[CarKey.responseKey.rawValue] as? [[String : AnyObject]]{
                            let syncedCars = self.syncData(remoteData: vehicles)
                            onSuccess(syncedCars)
                        }
                    }
                    catch{
                        onFail(error.localizedDescription)
                    }
                }
        }
    }
    
    
    
    // MARK: - Basic Operations -
    
    /// Helper Method to Add New Car.
    ///
    /// - Parameters:
    ///   - dict: input Dictiornay Object.
    ///   - shouldSaveContext: Flag to determine to Save the Context or not (core data), default value is true.
    /// - Returns: Inilaized Car.
    
    func addNewCar(dict : [String: AnyObject], shouldSaveContext : Bool = true) -> Car {
        let newCar = Car(context: context)
        if let id = dict[CarKey.idKey.rawValue] as? Int{
            newCar.id = Int16(id)
        }
        if let firstRegistration = dict[CarKey.firstRegistrationKey.rawValue] as? String{
            newCar.first_registration = firstRegistration
        }
        if let accidentFree = dict[CarKey.accidentFreeKey.rawValue] as? Bool{
            newCar.accidentFree = accidentFree
        }
        if let powerKW = dict[CarKey.powerKWKey.rawValue] as? Int{
            newCar.powerKW = Int32(powerKW)
        }
        if let address = dict[CarKey.address.rawValue] as? String{
            newCar.address = address
        }
        if let price = dict[CarKey.price.rawValue] as? Int{
            newCar.price = Int32(price)
        }
        if let mileage = dict[CarKey.mileage.rawValue] as? Int{
            newCar.mileage = Int32(mileage)
        }
        if let make = dict[CarKey.make.rawValue] as? String{
            newCar.make = make
        }
        if let fuelType = dict[CarKey.fuelType.rawValue] as? String{
            newCar.fuelType = fuelType
        }
        if let images = dict[CarKey.images.rawValue] as? [String]{
            newCar.images = images as NSObject
        }
        if shouldSaveContext {
            saveContext()
        }
        return newCar
    }
    
    
    /// Helper Method to delete for the Car.
    ///
    /// - Parameter dict: Dictionary for Deleted Car.
    /// - Returns: Refrence to Car searchable in Local Data.
    
    func removeCar(dict : [String: AnyObject]) -> Car {
        let toBeRemovedCar = addNewCar(dict: dict as [String : AnyObject],shouldSaveContext: false)
        context.delete(toBeRemovedCar)
        saveContext()
        return toBeRemovedCar
    }
    
    
    /// Update Car If found with the new properties.
    ///
    /// - Parameter car: the desired updated Car.
    
    func updateCar(car : Car) {
        let localCars = loadLocalCars()
        if let fitchedCar = localCars.filter({$0.id == car.id}).first{
            fitchedCar.isFavorited = car.isFavorited
            saveContext()
            sendNotification(updatedCar: car)
        }
    }
    
    
    
    /// Wrapper to Core Data Save Context.
    private func saveContext() {
        APP_DELEGATE.saveContext()
    }
    
    
    /// Synchronization between Local and Remote Responses. If the car is Found Locally then return it from Local Storage, other wise Create new record in DB from the remote car and return it.
    ///
    /// - Parameter remoteData: the Remote Fitched Cars.
    /// - Returns: Synchronized list of Cars.
    private func syncData(remoteData : [[String : AnyObject]]) -> [Car] {
        var result :[Car] = []

        let localCars = loadLocalCars()
        
        for remoteCar in remoteData{
            if let id = remoteCar[CarKey.idKey.rawValue] as? Int16{
                
                if localCars.contains(where: {$0.id == id}){
                    if let localCar = localCars.filter({$0.id == id}).first{
                        result.append(localCar)
                    }
                }
                else{
                    let newCar = addNewCar(dict: remoteCar)
                    result.append(newCar)
                }
            }
        }
        return result
    }

    
}


