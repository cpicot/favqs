//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Private Properties
    private weak var delegate: LoginDelegate?

    // MARK: - Setup
    static func instantiate(webServiceClient: WebServiceClient,
                            delegate: LoginDelegate) -> UIViewController {
        let viewController = StoryboardScene.LoginViewController.loginViewController.instantiate()
        viewController.delegate = delegate
        return viewController
    }

    // MARK: - Override Funcs
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Actions
private extension LoginViewController {
    @IBAction func loginTouchUpInside(_ sender: Any) {
        login()
    }
}

// MARK: - Private Funcs
private extension LoginViewController {
    func login() {
        // TODO: Make WS request
        delegate?.launchApp()
    }
}
