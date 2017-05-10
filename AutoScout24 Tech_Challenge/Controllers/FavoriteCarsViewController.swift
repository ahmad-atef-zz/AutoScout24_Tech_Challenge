//
//  FavoriteCarsViewController.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/9/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import UIKit

class FavoriteCarsViewController: UIViewController {
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    
    var refreshControl = UIRefreshControl()
    static var carViewModel : FavoriteCarsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullToRefresh()
        FavoriteCarsViewController.carViewModel = FavoriteCarsViewModel(viewable: self)
        FavoriteCarsViewController.carViewModel?.registerForNotification()
        listCars()
    }
    
    func addPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(listCars), for: .valueChanged)
    }
    
    func listCars() {
        refreshControl.beginRefreshing()
        FavoriteCarsViewController.carViewModel?.loadCars()
    }
}

//MARK: - TableView Delegates -

extension FavoriteCarsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteCarsViewController.carViewModel!.numberOfItems()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.Identifier) as? CarCell{
            if let car = FavoriteCarsViewController.carViewModel?.itemAtIndex(index: indexPath.row){
                cell.milage.text = "\(car.mileage) Km"
                cell.manufacturer.text = car.make!
                cell.price.text = "\(car.price) $"
                cell.isFavorited.isOn = car.isFavorited
                cell.car = car
            }
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - MVVM -
extension FavoriteCarsViewController: CarViewable {
    func reloadData() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    func showError(error: String){
        
    }
}

