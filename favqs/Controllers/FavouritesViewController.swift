//
//  Coordinator.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import RxSwift
import Reusable

final class FavouritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties
    private weak var delegate: FavouriteDelegate?
    private enum SectionsType: Int, CaseIterable {
        case profile
        case favourites
    }
    private var userFavouritesViewModel: UserFavouritesViewModel?
    private var disposeBag: DisposeBag = DisposeBag()

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

        tableView.register(cellType: UserTableViewCell.self)
        tableView.register(cellType: QuoteTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        // TODO: Use adapted instead to handle datasource
        tableView.dataSource = self
        tableView.delegate = self

        userFavouritesViewModel = UserFavouritesViewModel()
        userFavouritesViewModel?.delegate = self
        userFavouritesViewModel?.refreshUserContent()
        userFavouritesViewModel?.refreshFavouriteContent()
    }
}

// MARK: - Actions
private extension FavouritesViewController {
    @IBAction func logoutTouchUpInside(_ sender: Any) {
        logout()
    }
}

extension FavouritesViewController: ViewModelDelegate {
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Private Funcs
private extension FavouritesViewController {
    func logout() {
        LogoutUseCase().execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.delegate?.logout()
            })
            .disposed(by: disposeBag)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionsType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionsType(rawValue: section) else { return 0 }

        switch sectionType {
        case .profile:
            return userFavouritesViewModel?.hasUserContent == true ? 1 : 0
        case .favourites:
            return userFavouritesViewModel?.quotes.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionsType(rawValue: indexPath.section) else { return UITableViewCell() }

        switch sectionType {
        case .profile:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserTableViewCell.self)
            userFavouritesViewModel?.setup(userCell: cell)
            return cell
        case .favourites:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: QuoteTableViewCell.self)
            userFavouritesViewModel?.setup(quoteCell: cell, for: indexPath.row)
            return cell
        }
    }

}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        guard let sectionType = SectionsType(rawValue: indexPath.section)
            else { return }

        if sectionType == .favourites,
           indexPath.row + 1 == userFavouritesViewModel?.quotes.count {
            userFavouritesViewModel?.refreshFavouriteContent()
        }
    }
}
