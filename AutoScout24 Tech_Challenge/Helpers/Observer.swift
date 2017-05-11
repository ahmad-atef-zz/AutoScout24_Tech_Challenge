//
//  Observer.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/10/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation



/// Subject is Responisnle for [ Notification & Managing Observers ].

protocol Subject {
    func addObserver(observers : Observer...)
    func removeObserver(observer : Observer)
    func sendNotification(updatedCar: Car)
}


/// For All Observers that are waiting to get Notified when a change from Subject has been Changed
protocol Observer : class {
    func didRecieveNotification(updatedCar: Car)
}

class SubjectBase: Subject {
    
    var observers : [Observer] = []
    private var collectionQueue = DispatchQueue(label: "colQ", attributes: .concurrent)
    
    func addObserver(observers: Observer...) {
        collectionQueue.sync {
            for newObserver in observers{
                self.observers.append(newObserver)
            }
        }
    }
    
    func removeObserver(observer: Observer) {
        collectionQueue.sync {
            self.observers = observers.filter({$0 !== observer})
        }
    }
    
    func sendNotification(updatedCar car: Car) {
        collectionQueue.sync {
            for observer in observers{
                observer.didRecieveNotification(updatedCar: car)
            }
        }
    }
}
