//
//  RestaurantDetailViewController.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

enum RestaurantAction {
    case phone(String)
    case message(String)
    case email(String)
    case website(URL)
}

protocol RestaurantsViewControllerDelegate: AnyObject {
    func viewController(_ viewController: RestaurantDetailViewController, triggeredAction action: RestaurantAction)
}

final class RestaurantDetailViewController: UIViewController, Storyboarded {

    var selectedRestaurant: Restaurant?
    weak var delegate: RestaurantsViewControllerDelegate?

    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: RestaurantDetailTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 32.0
        tableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView.register(UINib(nibName: ContactInfoTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ContactInfoTableViewCell.reuseIdentifier)
        if let selectedRestaurant = selectedRestaurant {
            dataSource = RestaurantDetailTableViewDataSource(restaurant: selectedRestaurant)
            tableView.dataSource = dataSource
        }
    }

}

// MARK:- UITableViewDelegate

extension RestaurantDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ContactInfoTableViewCell)?.delegate = self
    }
}

// MARK: - ContactInfoTableViewCellDelegate

extension RestaurantDetailViewController: ContactInfoTableViewCellDelegate {
    func cell(_ cell: ContactInfoTableViewCell, didSelectMessageButton button: UIButton) {
        guard let info = cell.viewModel?.info else { return }
        delegate?.viewController(self, triggeredAction: RestaurantAction.message(info))
    }
    
    func cell(_ cell: ContactInfoTableViewCell, didSelectCallButton button: UIButton) {
        guard let info = cell.viewModel?.info else { return }
        delegate?.viewController(self, triggeredAction: RestaurantAction.phone(info))
    }
    
    func cell(_ cell: ContactInfoTableViewCell, didSelectEmailButton button: UIButton) {
        guard let info = cell.viewModel?.info else { return }
        delegate?.viewController(self, triggeredAction: RestaurantAction.email(info))
    }
    
    func cell(_ cell: ContactInfoTableViewCell, didSelectWebsiteButton button: UIButton) {
        guard let info = cell.viewModel?.info, let url = URL(string: info) else { return }
        delegate?.viewController(self, triggeredAction: RestaurantAction.website(url))
    }
}

