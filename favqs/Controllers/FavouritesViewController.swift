//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit

final class FavouritesViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Private Properties
    private weak var delegate: FavouriteDelegate?

    // MARK: - Setup
    static func instantiate(webServiceClient: WebServiceClient,
                            coordinator: FavouriteDelegate) -> FavouritesViewController {
        let viewController = StoryboardScene.FavouritesViewController.initialScene.instantiate()
        viewController.delegate = coordinator
        return viewController
    }

    // MARK: - Override Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Actions
private extension FavouritesViewController {
    @IBAction func logoutTouchUpInside(_ sender: Any) {
        logout()
    }
}

// MARK: - Private Funcs
private extension FavouritesViewController {
    func logout() {
        // Reset keychain
        delegate?.logout()
    }
}
