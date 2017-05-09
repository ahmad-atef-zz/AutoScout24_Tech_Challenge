//
//  CarListViewModel.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/9/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation


class Car {
    
}

protocol CarDataSourceProtcol {
    func loadCars()
    func numberOfItems() -> Int
    func itemAtIndex (index : Int) -> Car
}

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
        }
    }
    
    func itemAtIndex(index: Int) -> Car {
        return dataSource[index]
    }

    func numberOfItems() -> Int {
        return dataSource.count
    }
}

