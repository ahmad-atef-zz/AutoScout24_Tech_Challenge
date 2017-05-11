//
//  CarListViewModel.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/9/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation



/// Protocol for all CarDataSourcable, the consumer of this protocol is someone who is interested in implementing the data source protocol related to Cars.

@objc protocol CarDataSourceProtcol {
    func loadCars()
    func numberOfItems() -> Int
    func itemAtIndex (index : Int) -> Car
    func updateCar(car: Car)
    func registerForNotification()
    @objc optional func removeCar(car: Car)
}


/// Protcol for all CarViewable, the consumers are someone who is intersted in implmenting the Car Viewing functions, like reloading data or Showing Errors.

protocol CarViewable {
    func reloadData()
    func showError(error: String)
}

class CarListViewModel : CarDataSourceProtcol{

    var dataSource : [Car] = []
    var carViewConsumer : CarViewable
    
    init(viewable : CarViewable) {
        self.carViewConsumer = viewable
    }
    func registerForNotification(){
        DBIntercotr.shared.addObserver(observers: self)
    }
    func loadCars() {
        loadRemoteCars()
    }
    
    private func loadRemoteCars() {
        DBIntercotr.shared.loadRemoteCars(onSuccess: { (cars) in
            self.dataSource.removeAll()
            self.dataSource = cars
            self.carViewConsumer.reloadData()
        }) { (error) in
            print(error)
            UIDecorator.shared.showMessage(title: "Error",
                                           body: error.description,
                                           alertType: .error)
        }
    }
    
    func itemAtIndex(index: Int) -> Car {
        return dataSource[index]
    }

    func numberOfItems() -> Int {
        return dataSource.count
    }
    func updateCar(car: Car) {
        DBIntercotr.shared.updateCar(car: car)
    }
}


//MARK: - Observer -

extension CarListViewModel : Observer{

    func didRecieveNotification(updatedCar: Car) {
        loadCars()
    }
}
