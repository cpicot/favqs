//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.isEnabled = false
        }
    }

    // MARK: - Private Properties
    private let loginUseCase = LoginUseCase()
    private weak var delegate: LoginDelegate?
    private let disposeBag: DisposeBag = DisposeBag()

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
//        emailTextField.text = "clement"
//        passwordTextField.text = "123456"
//        loginButton.isEnabled = true

        // setup input events
        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
            self?.passwordTextField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        passwordTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.passwordTextField.resignFirstResponder()
                self?.signIn()
            }).disposed(by: disposeBag)

        // setup input checks
        let valids = [passwordTextField, emailTextField]
        .map { field in
            field.rx.text.map({ _ in return field.text?.isEmpty == false
            })
        }
        Observable.combineLatest(valids) { iterator -> Bool in
            return iterator.allSatisfy({ $0 == true })
        }
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}

// MARK: - Actions
private extension LoginViewController {
    @IBAction func loginTouchUpInside(_ sender: Any) {
        view.endEditing(true)
        signIn()
    }
}

private extension LoginViewController {
    func signIn() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }

        self.isLoading(true)

        loginUseCase.execute(email: email,
                             password: password) { [weak self] success, error in
            guard let strongSelf = self else { return }

            strongSelf.isLoading(false)

            if success {
                strongSelf.delegate?.launchApp()
            } else {
                let alert = UIAlertController(title: "Login error",
                                              message: error?.description,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: .cancel,
                                              handler: nil))
                strongSelf.present(alert,
                                   animated: true,
                                   completion: nil)
            }
        }
    }

    func isLoading(_ isLoading: Bool) {
        loginButton.isHidden = isLoading
        activityIndicator.isHidden = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
    }
}
