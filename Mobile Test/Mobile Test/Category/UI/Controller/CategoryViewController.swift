//
//  CategoryViewController.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var dataSource = CategoryTableViewDataSource()
    private lazy var service = CategoryServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCells()
    
        service.getCategories { result in
            
            switch result {
            case .success(let categories):
                self.dataSource.viewModels.removeAll()
                self.dataSource.viewModels.append(contentsOf: categories.viewModelValues)
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
            
            case .failure (let error):
                print(error)
                // TODO error management
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CategoryTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
    }
}

// MARK: - Storyboarded

extension CategoryViewController: Storyboarded {}

// MARK:- UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {}
