//
//  RestaurantCoordinator.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

final class RestaurantCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorNavigationDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let restaurantsViewController = RestaurantListViewController.instanciate()
        restaurantsViewController.delegate = self
        navigationController.pushViewController(restaurantsViewController, animated: true)
    }
    
    func end() {
        childCoordinators.removeAll()
        delegate?.coordinatorDidEndFlow(self)
    }
    
    // MARK: Navigation
    
    fileprivate func callPhoneNumber(_ phoneNumber: String) {
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            WarningPresenter.presentAlert(in: navigationController, message: "Invalid phone number", title: "Warning")
        }
    }
    
    fileprivate func sendMessageToPhoneNumber(_ phoneNumber: String) {
        
        let phoneNumberToUse = phoneNumber.contains("sms:") ? phoneNumber : "sms:\(phoneNumber)"
        if let url = URL(string: phoneNumberToUse), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            WarningPresenter.presentAlert(in: navigationController, message: "Invalid phone number", title: "Warning")
        }
    }
    
    fileprivate func sendEmail(_ email: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            
            navigationController.present(mail, animated: true, completion: nil )
        } else {
            WarningPresenter.presentAlert(in: navigationController, message: "You cannot send email at the moment.", title: "Warning")
        }
    }
}

// MARK: - RestaurantsViewControllerDelegate

extension RestaurantCoordinator: RestaurantsViewControllerDelegate {
    func viewController(_ viewController: RestaurantDetailViewController, triggeredAction action: RestaurantAction) {
        switch action {
        case .phone (let number):
            callPhoneNumber(number)
        case .message(let phoneNumber):
            sendMessageToPhoneNumber(phoneNumber)
        case .email(let email):
            sendEmail(email)
        case .website(let url):
            let webView = SFSafariViewController(url: url)
            navigationController.pushViewController(webView, animated: true)
        }
    }
}

// MARK: - MessageComposerDelegate

extension RestaurantCoordinator: MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Do nothing.
    }
}

// MARK: - RestaurantListViewControllerNavigationDelegate

extension RestaurantCoordinator: RestaurantListViewControllerNavigationDelegate {
    func viewController(_ viewController: UIViewController, didSelectRestaurant restaurant: Restaurant) {
        
        let detailViewController = RestaurantDetailViewController.instanciate()
        detailViewController.delegate = self
        detailViewController.selectedRestaurant = restaurant
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
