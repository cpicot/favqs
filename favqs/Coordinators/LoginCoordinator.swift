//
//  LoginCoordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import RxSwift

protocol LoginDelegate: AnyObject {
    func launchApp()
}

final class LoginCoordinator: NavCoordinator {

    var mainViewController: UIViewController?
    var childCoordinators: [Coordinator] = []
    var finished: Single<Void> { return finishedPublisher.asSingle() }

    private weak var delegate: MyAppDelegate?
    private let finishedPublisher = PublishSubject<Void>()
    private let webServiceClient: WebServiceClient

    init(webServiceClient: WebServiceClient,
         delegate: MyAppDelegate?) {
        self.webServiceClient = webServiceClient
        self.delegate = delegate
    }

    func start() -> Single<UIViewController> {
        return Single<UIViewController>.create { [weak self] single -> Disposable in
            guard let strongSelf = self else { return Disposables.create {} }

            let controller: UIViewController = LoginViewController
                .instance(webServiceClient: strongSelf.webServiceClient,
                          delegate: strongSelf)
            strongSelf.mainViewController = controller

            single(.success(controller))

            return Disposables.create {}
        }
    }
}

extension LoginCoordinator: LoginDelegate {

    func launchApp() {
        print("launchApp")
        finishedPublisher.onNext(())
        finishedPublisher.onCompleted()
    }

}
