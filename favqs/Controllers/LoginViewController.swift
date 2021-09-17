//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    // MARK: - Private Properties
    private let loginUseCase = LoginUseCase()
    private weak var delegate: LoginDelegate?
    @IBOutlet weak var loginButton: UIButton!

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

        // TODO: remove this, moked values
        emailTextField.text = "clement"
        passwordTextField.text = "123456"
    }
}

// MARK: - Actions
private extension LoginViewController {
    @IBAction func loginTouchUpInside(_ sender: Any) {
        // TODO: improve by checking with a nice error handling (via rx)
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty
        else { return }

        loginButton.isEnabled = false
        loginUseCase.execute(email: email,
                             password: password) { [weak self] success, error in
            self?.loginButton.isEnabled = true
            if success {
                self?.delegate?.launchApp()
            } else {
                // present UI alert VC
                print(error?.description ?? "login error")
            }
        }
    }
}
