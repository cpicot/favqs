//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import RxSwift

// MARK: Protocol

protocol Coordinator: AnyObject {
    var mainViewController: UIViewController? { get }
    var childCoordinators: [Coordinator] { get set }
    func start() -> Single<UIViewController>
    var finished: Single<Void> { get }

    func present(childCoordinator coordinator: Coordinator,
                 animated: Bool,
                 completion: (() -> Void)?)
    func dismissChildCoordinator(animated: Bool,
                                 completion: (() -> Void)?)

    func push(childCoordinator: Coordinator)
    func popChildCoordinator()
}

// MARK: Default Implementation
extension Coordinator {

    func reset() {
        childCoordinators.removeAll()
    }

    func present(childCoordinator coordinator: Coordinator,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        childCoordinators.append(coordinator)
        if let controller = coordinator.mainViewController {
            controller.modalPresentationStyle = .overFullScreen
            self.mainViewController?.present(controller,
                                             animated: animated,
                                             completion: completion)
        }
    }

    func dismissChildCoordinator(animated: Bool = true,
                                 completion: (() -> Void)? = nil) {
        self.mainViewController?.dismiss(animated: animated,
                                         completion: completion)
        _ = childCoordinators.popLast()
    }

    func push(childCoordinator coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func popChildCoordinator() {
        _ = childCoordinators.popLast()
    }

    func popChildCoordinator(coordinator: Coordinator) {
        if let index = childCoordinators
            .enumerated()
            .filter({ $0.element === coordinator })
            .map({ $0.offset }).first {
            childCoordinators.remove(at: index)
        }
    }

    func pushChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll()
        _ = coordinator.start().subscribe(onSuccess: {  [weak self] _ in
            self?.push(childCoordinator: coordinator)
        })
        _ = coordinator.finished.subscribe(onSuccess: { [weak self] _  in
            self?.popChildCoordinator()
        })
    }

    func presentChildCoordinator(_ coordinator: Coordinator) {
        _ = coordinator.start().subscribe(onSuccess: { [weak self] controller in
            self?.present(childCoordinator: coordinator)
        })
        _ = coordinator.finished.subscribe(onSuccess: { [weak self] success in
            self?.dismissChildCoordinator()
        })
    }

}
