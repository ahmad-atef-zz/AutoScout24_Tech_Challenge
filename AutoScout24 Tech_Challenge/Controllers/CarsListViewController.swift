//
//  ViewController.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/9/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import UIKit

class CarsListViewController: UIViewController {

    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    var dataSource : [String] = []
    var refreshControl = UIRefreshControl()
    static var carViewModel : CarListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullToRefresh()
        CarsListViewController.carViewModel = CarListViewModel(viewable: self)
        listCars()
    }

    func addPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(listCars), for: .valueChanged)
    }
    
    func listCars() {
        refreshControl.beginRefreshing()
        CarsListViewController.carViewModel?.loadCars()
    }
}

//MARK: - TableView Delegates -

extension CarsListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarsListViewController.carViewModel!.numberOfItems()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.Identifier) as? CarCell{
            if let car = CarsListViewController.carViewModel?.itemAtIndex(index: indexPath.row){
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
extension CarsListViewController: CarViewable {
    func reloadData() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    func showError(error: String){
        
    }
}


//MARK: - UI Car Cell -
class CarCell: UITableViewCell {
    var car : Car?
    static let Identifier = "CarCell"
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var isFavorited: UISwitch!
    @IBAction func favoriteIsTapped(_ sender: Any) {
        car?.isFavorited = isFavorited.isOn
        CarsListViewController.carViewModel?.updateCar(car: car!)
    }
}
