//
//  FavouritesCoordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

protocol FavouriteDelegate: AnyObject {
    func logout()
}

final class FavouritesCoordinator: NavCoordinator {
    var mainViewController: UIViewController?
    var childCoordinators: [Coordinator] = []
    var finished: Single<Void> {
        return finishedPublisher.asSingle()
    }

    private let finishedPublisher = PublishSubject<Void>()
    private let webServiceClient: WebServiceClient
    private weak var delegate: MyAppDelegate?

    init(webServiceClient: WebServiceClient,
         delegate: MyAppDelegate?) {
        self.webServiceClient = webServiceClient
        self.delegate = delegate
    }

    func start() -> Single<UIViewController> {
        return Single<UIViewController>.create { [weak self] single -> Disposable in
            guard let strongSelf = self else { return Disposables.create {} }

            let controller: UIViewController = FavouritesViewController
                .instantiate(webServiceClient: strongSelf.webServiceClient,
                             coordinator: strongSelf)
            let nav = UINavigationController(rootViewController: controller)
            strongSelf.mainViewController = nav

            single(.success(nav))

            return Disposables.create {}
        }
    }

}

extension FavouritesCoordinator: FavouriteDelegate {
    func logout() {
        finishedPublisher.onNext(())
        finishedPublisher.onCompleted()
    }
}
