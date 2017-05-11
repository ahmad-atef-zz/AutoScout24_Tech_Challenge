//
//  InternetChecker.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/11/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation
import ReachabilitySwift


enum ReachabilityStatus: String{
    case REACHABLEVIAWIFI = "Reachable via WiFi"
    case REACHABLEVIACELLULAR = "Reachable via Cellular"
    case NOTREACHABLE = "Not Connected to the Internet"
    case UNABLETOSTART = "Unable to start notifier"
}


class InternetChecker: NSObject {
    static let shared = InternetChecker()
    fileprivate let reachability = Reachability()!
    
    func checkForInternet(_ withResult: @escaping ((ReachabilityStatus) -> Void))  {
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    withResult(.REACHABLEVIAWIFI)
                } else {
                    withResult(.REACHABLEVIACELLULAR)
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            DispatchQueue.main.async {
                withResult(.NOTREACHABLE)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            withResult(.UNABLETOSTART)
        }
    }
    
    func isReachable() -> Bool {
        return self.reachability.isReachable
    }
}
