//
//  ItemTableViewCell.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class ItemTableViewCell: UITableViewCell, ViewModelConfigurable {

    static let reuseIdentifier = "ItemTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ItemTableViewCellViewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

// MARK: View Model

struct ItemTableViewCellViewModel: ReusableCellViewModel {
    let reuseIdentifier = ItemTableViewCell.reuseIdentifier
    let title: String
    let description: String?
    
    init(category: Category) {
        self.title = category.type.rawValue.uppercased()
        self.description = category.description
    }
    
    init(restaurant: Restaurant) {
        self.title = restaurant.title
        self.description = restaurant.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
