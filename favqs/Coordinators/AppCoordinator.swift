//
//  AppCoordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import RxSwift

protocol MyAppDelegate: AnyObject {
    func showApp()
    func showLogin()
}

class AppCoordinator: Coordinator {

    var mainViewController: UIViewController?
    var childCoordinators: [Coordinator] = []
    var finished: Single<Void> { return finishedPublisher.asSingle() }

    private let window: UIWindow
    private let finishedPublisher = PublishSubject<Void>()
    private var appRootViewController: UIViewController?
    private let disposeBag = DisposeBag()

    private let webServiceClient: WebServiceClient

    init(window: UIWindow) {
        self.window = window
        //            self.mainViewController = StoryboardScene.WaitingViewController.initialScene.instantiate()

        self.webServiceClient = WebServiceClient()
    }

    func start() -> Single<UIViewController> {
        // Should not be called
        return Single.just(UIViewController())
    }

    func launch() {
        let isLogged = false
        if isLogged {
            showApp()
        } else {
            showLogin()
        }
    }
}

private extension AppCoordinator {

    func refreshRootVC(with viewController: UIViewController) {
        if window.rootViewController == nil {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        } else {
            window.rootViewController = viewController
        }
        appRootViewController = viewController
    }
}

extension AppCoordinator: MyAppDelegate {
    func showApp() {
        print("showApp")
    }

    func showLogin() {
        let coordinator: LoginCoordinator = LoginCoordinator(
            webServiceClient: webServiceClient,
            delegate: self)
        push(childCoordinator: coordinator)
        _ = coordinator.start().subscribe(onSuccess: { [weak self] controller in
            self?.refreshRootVC(with: controller)
        })
        _ = coordinator.finished.subscribe(onSuccess: { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.popChildCoordinator()
            strongSelf.showApp()
        })
    }

}
