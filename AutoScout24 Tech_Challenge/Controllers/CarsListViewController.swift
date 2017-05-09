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
    var carViewModel : CarListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullToRefresh()
        carViewModel = CarListViewModel(viewable: self)
        listCars()
    }

    func addPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(listCars), for: .valueChanged)
    }
    
    func listCars() {
        carViewModel?.loadCars()
    }
}

//MARK: - TableView Delegates -

extension CarsListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carViewModel!.numberOfItems()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.Identifier) as? CarCell{
            if let car = carViewModel?.itemAtIndex(index: indexPath.row){
                
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
    static let Identifier = "CarCell"
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var isFavorited: UISwitch!
}
