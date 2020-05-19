//
//  ContactInfoTableViewCell.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

protocol ContactInfoTableViewCellDelegate: AnyObject {
    func cell(_ cell: ContactInfoTableViewCell, didSelectMessageButton button: UIButton)
    func cell(_ cell: ContactInfoTableViewCell, didSelectCallButton button: UIButton)
    func cell(_ cell: ContactInfoTableViewCell, didSelectEmailButton button: UIButton)
    func cell(_ cell: ContactInfoTableViewCell, didSelectWebsiteButton button: UIButton)
}

final class ContactInfoTableViewCell: UITableViewCell, ViewModelConfigurable {
    static let reuseIdentifier = "ContactInfoTableViewCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    
    var viewModel: ContactInfoTableViewCellViewModel?
    
    weak var delegate: ContactInfoTableViewCellDelegate?
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ContactInfoTableViewCellViewModel else { return }
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.info
        
        switch viewModel.informationType {
        case .phone, .tollfree:
            guard let icons = viewModel.informationType.icons else { return }
            leftButton.setBackgroundImage(icons[0], for: .normal)
            rightButton.setBackgroundImage(icons[1], for: .normal)
            
        case .email:
            guard let icons = viewModel.informationType.icons else { return }
            leftButton.isHidden = true
            rightButton.setBackgroundImage(icons[0], for: .normal)
        case .fax:
            leftButton.isHidden = true
            rightButton.isHidden = true
        case .website:
            guard let icons = viewModel.informationType.icons else { return }
            leftButton.isHidden = true
            rightButton.setBackgroundImage(icons[0], for: .normal)
        }
    }
    
    // MARK: Action
    
    @IBAction func leftButtonTouchUpInside(_ sender: UIButton) {
        if let viewModel = viewModel {
            switch viewModel.informationType {
            case .phone, .tollfree:
                delegate?.cell(self, didSelectMessageButton: sender)
            default:
                return
            }
        }
    }
    
    @IBAction func rightButtonTouchUpInside(_ sender: UIButton) {
        if let viewModel = viewModel {
            switch viewModel.informationType {
            case .phone, .tollfree:
                delegate?.cell(self, didSelectCallButton: sender)
                
            case .email:
                delegate?.cell(self, didSelectEmailButton: sender)
                
            case .website:
                delegate?.cell(self, didSelectWebsiteButton: sender)
            default:
                return
            }
        }
    }
}

// MARK: - View Model

struct ContactInfoTableViewCellViewModel: ReusableCellViewModel {
    let reuseIdentifier = ContactInfoTableViewCell.reuseIdentifier
    let title: String
    let info: String
    let informationType: InformationType
    
    init(title: String, info: String, informationType: InformationType) {
        self.title = title.uppercased()
        self.info = info
        self.informationType = informationType
    }
}

enum InformationType {
    case phone
    case email
    case fax
    case tollfree
    case website
    
    var icons: [UIImage]? {
        switch self {
        case .phone, .tollfree:
            return [UIImage(systemName: "message")!, UIImage(systemName: "phone")!]
        case .email:
            return [UIImage(systemName: "envelope")!]
        case .fax:
            return nil
        case .website:
            return [UIImage(systemName: "arrowshape.turn.up.right")!]
        }
    }
}

