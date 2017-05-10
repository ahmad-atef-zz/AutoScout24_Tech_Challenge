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
    @IBOutlet weak var emptyView: UIView!
    
    //MARK: - Properties -
    
    var refreshControl = UIRefreshControl()
    static var carViewModel : FavoriteCarsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullToRefresh()
        FavoriteCarsViewController.carViewModel = FavoriteCarsViewModel(viewable: self)
        FavoriteCarsViewController.carViewModel?.registerForNotification()
        listCars()
        manageEmptyView()
    }
    
    func addPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(listCars), for: .valueChanged)
    }
    
    func listCars() {
        refreshControl.beginRefreshing()
        FavoriteCarsViewController.carViewModel?.loadCars()
    }
    
    func manageEmptyView() {
        UIView.animate(withDuration: 0.4) {
            self.emptyView.alpha = (FavoriteCarsViewController.carViewModel!.numberOfItems() > 0) ? 0 : 1
        }
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCarCell.Identifier) as? FavoriteCarCell{
            if let car = FavoriteCarsViewController.carViewModel?.itemAtIndex(index: indexPath.row){
                cell.milage.text = "\(car.mileage) Km"
                cell.manufacturer.text = car.make!
                cell.price.text = "\(car.price) $"
                cell.car = car
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - MVVM -
extension FavoriteCarsViewController: CarViewable {
    func reloadData() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
        manageEmptyView()
    }
    func showError(error: String){
        
    }
}

//MARK: - UI Favorite Car Cell -

class FavoriteCarCell: UITableViewCell {
    var car : Car?
    static let Identifier = "FavoriteCarCell"
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBAction func unFavoriteIsTapped(_ sender: Any){
        car?.isFavorited = false
        FavoriteCarsViewController.carViewModel?.updateCar(car: car!)
    }
}

