//
//  CategoryTableViewCell.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell, ViewModelConfigurable {

    static let reuseIdentifier = "CategoryTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? CategoryTableViewCellViewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

// MARK: View Model

struct CategoryTableViewCellViewModel: ReusableCellViewModel {
    let reuseIdentifier = CategoryTableViewCell.reuseIdentifier
    let title: String
    let description: String?
    
    init(category: Category) {
        self.title = category.categoryType.rawValue.uppercased()
        self.description = category.description
    }
}
