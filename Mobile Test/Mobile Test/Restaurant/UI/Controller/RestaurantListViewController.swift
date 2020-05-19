//
//  RestaurantListViewController.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

protocol RestaurantListViewControllerNavigationDelegate: AnyObject {
    func viewController(_ viewController: UIViewController, didSelectRestaurant restaurant: Restaurant)
}

final class RestaurantListViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var service = RestaurantService()
    private lazy var restaurants = [Restaurant]()
    private var dataSource: RestaurantListTableViewDataSource?
    
    weak var delegate: RestaurantListViewControllerNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"
        
        tableView.contentInset.top = 32.0
        tableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: ItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        
        service.getRestaurants { result  in
            switch result {
            case .success(let restaurants):
                self.restaurants.removeAll()
                self.restaurants.append(contentsOf: restaurants)
                
                self.dataSource = RestaurantListTableViewDataSource(restaurants: restaurants)
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
                
            case .failure (_):
                // TODO better error handling.
                
                WarningPresenter.presentAlert(in: self, message: "An error occured please try again later.", title: "Warning")
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension RestaurantListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        delegate?.viewController(self, didSelectRestaurant: restaurant)
    }
}
