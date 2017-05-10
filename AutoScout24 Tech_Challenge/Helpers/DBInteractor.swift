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
    
    func updateCar(car : Car) {
        let localCars = loadLocalCars()
        if let fitchedCar = localCars.filter({$0.id == car.id}).first{
            fitchedCar.isFavorited = car.isFavorited
            saveContext()
            sendNotification(updatedCar: car)
        }
    }
    
    private func saveContext() {
        APP_DELEGATE.saveContext()
    }
    
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
                    let newCar = Car(context: context)
                    if let id = remoteCar[CarKey.idKey.rawValue] as? Int16{
                        newCar.id = id
                    }
                    if let firstRegistration = remoteCar[CarKey.firstRegistrationKey.rawValue] as? String{
                        newCar.first_registration = firstRegistration
                    }
                    if let accidentFree = remoteCar[CarKey.accidentFreeKey.rawValue] as? Bool{
                        newCar.accidentFree = accidentFree
                    }
                    if let powerKW = remoteCar[CarKey.powerKWKey.rawValue] as? Int32{
                        newCar.powerKW = powerKW
                    }
                    
                    if let address = remoteCar[CarKey.address.rawValue] as? String{
                        newCar.address = address
                    }
                    if let price = remoteCar[CarKey.price.rawValue] as? Int32{
                        newCar.price = price
                    }
                    if let mileage = remoteCar[CarKey.mileage.rawValue] as? Int32{
                        newCar.mileage = mileage
                    }
                    if let make = remoteCar[CarKey.make.rawValue] as? String{
                        newCar.make = make
                    }
                    if let fuelType = remoteCar[CarKey.fuelType.rawValue] as? String{
                        newCar.fuelType = fuelType
                    }
                    if let images = remoteCar[CarKey.images.rawValue] as? [String]{
                        newCar.images = images as NSObject
                    }
                    result.append(newCar)
                    saveContext()
                }
            }
        }
        return result
    }
    
    
}


