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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullToRefresh()
    }

    func addPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(listCars), for: .valueChanged)
    }
    
    func listCars() {
        
    }
}

//MARK: - TableView Delegates -

extension CarsListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.Identifier) as? CarCell{
            return cell
        }
        return UITableViewCell()
    }
}


class CarCell: UITableViewCell {
    static let Identifier = "CarCell"
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var isFavorited: UISwitch!
}
