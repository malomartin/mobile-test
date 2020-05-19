//
//  RestaurantListTableViewDataSource.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-19.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class RestaurantListTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModels = [ReusableCellViewModel]()
    
    init(restaurants: [Restaurant]) {
        self.viewModels.append(contentsOf: restaurants.viewModelValues)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
        (cell as? ViewModelConfigurable)?.configure(with: viewModel)
        return cell
    }
}

// MARK: - Category Extension

extension Sequence where Element == Restaurant {
    
    var viewModelValues: [ReusableCellViewModel] {
        return map({ ItemTableViewCellViewModel(restaurant: $0) })
    }
}
