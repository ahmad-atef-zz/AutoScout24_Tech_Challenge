//
//  FavoriteCarsViewModel.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/9/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation


class FavoriteCarsViewModel : CarDataSourceProtcol{
    
    var dataSource : [Car] = []
    var carViewConsumer : CarViewable
    
    init(viewable : CarViewable) {
        self.carViewConsumer = viewable
    }
    
    func registerForNotification() {
        DBIntercotr.shared.addObserver(observers: self)
    }
    func loadCars() {
        loadLocalCars()
    }
    private func loadLocalCars() {
        let localCars = DBIntercotr.shared.loadLocalCars(favoritesOnly: true)
        dataSource.removeAll()
        dataSource = localCars
        carViewConsumer.reloadData()
    }
    func numberOfItems() -> Int{
        return dataSource.count
    }
    
    func itemAtIndex (index : Int) -> Car{
        return dataSource[index]
    }
    
    func updateCar(car: Car){
        DBIntercotr.shared.updateCar(car: car)
    }
    
    func removeCar(car: Car) {
        DBIntercotr.shared.removeCar(car: car)
    }
    
}

extension FavoriteCarsViewModel : Observer{
    func didRecieveNotification(updatedCar: Car) {
        loadCars()
    }
}
