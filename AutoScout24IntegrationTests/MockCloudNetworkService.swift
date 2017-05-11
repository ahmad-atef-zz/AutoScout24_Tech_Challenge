//
//  MockCloudNetworkService.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/11/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation

@testable import AutoScout24_Tech_Challenge

public class MockCloudNetworkService: CloudNetworkService {
    
    
    public lazy var mockedCars : [Car] = {
       let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "testing_cars", ofType: "plist")!
        let array = NSArray(contentsOfFile: path) as! [[String : Any]]
        var result :[Car] = []
        for item in array{
            result.append(DBIntercotr.shared.addNewCar(dict: item as [String : AnyObject], shouldSaveContext: false))
        }
        return result
    }()
    public func loadRemoteCars(manufacturer : String, onSuccess:@escaping ([Car]) -> Void, onFail: @escaping (String) -> Void){
        onSuccess(mockedCars)
    }
}
