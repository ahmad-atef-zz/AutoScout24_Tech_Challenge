//
//  Router.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/10/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation
import Alamofire


struct CompassPoint {
    
    static let TESTING = "http://sumamo.de/iOS-TechChallange/api/"
    static let STAGING = ""
    static let PRODUCTION = ""
}

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
}

let timeoutInterval = TimeInterval(10 * 1000)

public enum Router: URLRequestConvertible {
    
    static let baseURLString = CompassPoint.TESTING
    
    case listCars(parms : String)
    
    public func asURLRequest() throws -> URLRequest {
        
        let result : (path : String, method : HTTPMethod) = {
            switch self {
            case .listCars(let make):
                return ("index/make=\(make).json",.get)
            }
        }()
        
        let url = URL(string: Router.baseURLString)
        var request = URLRequest(url: (url?.appendingPathComponent(result.path))!)
        request.httpMethod = result.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = timeoutInterval
        
        return request
    }
}
