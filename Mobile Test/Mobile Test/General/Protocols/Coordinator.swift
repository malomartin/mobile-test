//
//  Coordinator.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

/// Object conforming to this protocol will control the execution flow of the feature.
protocol Coordinator {
    
    /// Contains sub-flows coordinator.
    var childCoordinators: [Coordinator] { get }
    
    /// `UINavigationController` used  to control the flow.
    var navigationController: UINavigationController { get }
    
    /// Instanciates the coordinator using a `UINavigationController`.
    init(navigationController: UINavigationController)
    
    /// Starts the feature flow.
    func start()
    
    /// Ends the flow.
    func end() 
}


// MARK: - Storyboarded

/// Use this protocol if you want a `UIViewController` to be easily instanciate from its `UIStoryboard`.
protocol Storyboarded {
    static func instanciate() -> Self
}

// Restricts the `Storyboarded` protocol to `UIViewController`.
extension Storyboarded where Self: UIViewController {
    
    /// Default method used to instanciate the `UIViewController` from its `UIStoryboard`.
    /// - Warning: The storyboard shall be named after the `UIViewController`.
    static func instanciate() -> Self {
        let className = NSStringFromClass(self).components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: className, bundle: nil)
        return storyboard.instantiateViewController(identifier: className)
    }
}

// MARK: - CoordinatorNavigationDelegate

protocol CoordinatorNavigationDelegate: AnyObject {
    func coordinatorDidEndFlow(_ coordinator: Coordinator)
}
