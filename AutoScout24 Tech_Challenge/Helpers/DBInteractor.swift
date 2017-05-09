//
//  DBInteractor.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/10/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation
import Alamofire

class DBIntercotr {
    static let shared = DBIntercotr()
    
    func loadLocalCars() {
        
    }
    
    func loadRemoteCars(onSuccess:@escaping ([Car]) -> Void, onFail: (String) -> Void) {
        Alamofire.request(Router.listCars(parms: "all"))
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                if response.result.isSuccess{
                    if let response = response.result.value {
                        onSuccess([Car(),Car()])
                    }
                }
        }
    }
}
