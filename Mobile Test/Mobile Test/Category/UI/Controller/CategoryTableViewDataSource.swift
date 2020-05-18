//
//  CategoryTableViewDataSource.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class CategoryTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModels = [ReusableCellViewModel]()
    
    init(categories: [Category]? = nil) {
        super.init()
        
        guard let categories = categories else { return }
        viewModels.append(contentsOf: categories.viewModelValues)
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

extension Sequence where Element == Category {
    
    var viewModelValues: [ReusableCellViewModel] {
        return map({ CategoryTableViewCellViewModel(category: $0) })
    }
}
