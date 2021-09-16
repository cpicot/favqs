//
//  NavigationCoordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit

protocol NavDelegate: AnyObject {
    func back()
}

protocol NavCoordinator: Coordinator, NavDelegate {
    var navigationController: UINavigationController { get }
}

// MARK: - Default Implementation
extension NavCoordinator {

    var navigationController: UINavigationController {
        guard let nav: UINavigationController =
                self.mainViewController as? UINavigationController else {
            fatalError("The rootViewController should be a UINavigationController")
        }
        return nav
    }

    func pushToRoot(viewController: UIViewController) {
        self.navigationController.setViewControllers([viewController], animated: false)
    }

    func back() {
        self.navigationController.popViewController(animated: true)
    }
}
