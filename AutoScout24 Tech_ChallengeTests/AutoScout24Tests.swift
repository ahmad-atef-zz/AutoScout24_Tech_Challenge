//
//  AutoScout24Tests.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/10/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import XCTest

@testable import AutoScout24_Tech_Challenge


class AutoScout24Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    
    func testCanAddCar() {
        
        let newCar : [String : Any] = ["ID" : 150,
                                       "FirstRegistration" : "7/2015",
                                       "AccidentFree" : true,
                                       "Images" : ["http://sumamo.de/iOS-TechChallange/assets/bmw/01.jpg"],
                                       "PowerKW" : 335,
                                       "Address" : "50667 Köln",
                                       "Price" : 123123,
                                       "Mileage" : 5678,
                                       "Make": "BMW",
                                       "FuelType": "Diesel"]
        let addedCar =  DBIntercotr.shared.addNewCar(dict: newCar as [String : AnyObject])
        let localCars = DBIntercotr.shared.loadLocalCars()
        XCTAssertTrue(localCars.contains(addedCar))
    }
    
    func testCanRemoveCar(){
        let dict : [String : Any] = ["ID" : 150,
                                       "FirstRegistration" : "7/2015",
                                       "AccidentFree" : true,
                                       "Images" : ["http://sumamo.de/iOS-TechChallange/assets/bmw/01.jpg"],
                                       "PowerKW" : 335,
                                       "Address" : "50667 Köln",
                                       "Price" : 123123,
                                       "Mileage" : 5678,
                                       "Make": "BMW",
                                       "FuelType": "Diesel"]
        let toBeRemovedCar = DBIntercotr.shared.removeCar(dict: dict as [String : AnyObject])
        let localCars = DBIntercotr.shared.loadLocalCars()
        
        XCTAssertFalse(localCars.contains(toBeRemovedCar))
    }
    
    
}
