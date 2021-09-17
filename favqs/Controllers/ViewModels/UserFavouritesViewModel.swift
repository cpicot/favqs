//
//  UserFavouritesViewModel.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import RxSwift

protocol ViewModelDelegate: AnyObject {
    func refresh()
}

final class UserFavouritesViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private let userUseCase = GetUserUseCase()
    private let favouritesUseCase = GetFavouritesUseCase()
    private var currentUser: UserResponse? {
        didSet {
            delegate?.refresh()
        }
    }
    private (set) var quotes: [Quote] = [] {
        didSet {
            delegate?.refresh()
        }
    }
    private var hasMore = true
    private var nextPage: Int = 0

    weak var delegate: ViewModelDelegate?
    var hasUserContent: Bool {
        currentUser != nil
    }

    func refreshUserContent() {
        userUseCase.execute { [weak self] user in
            self?.currentUser = user
        }
    }

    func refreshFavouriteContent() {
        guard hasMore else { return }

        favouritesUseCase.execute(page: nextPage) { [weak self] response in
            guard let strongSelf = self,
                  let response = response else { return }

            strongSelf.quotes.append(contentsOf: response.quotes)
            strongSelf.nextPage = response.page + 1
            strongSelf.hasMore = !response.lastPage
        }
    }

    func setup(userCell: UserTableViewCell) {
        userCell.setup(name: currentUser?.login,
                   favCount: currentUser?.publicFavoritesCount, // TODO: handle private quotes?
                   avatar: currentUser?.picURL)
    }

    func setup(quoteCell: QuoteTableViewCell, for index: Int) {
        guard quotes.count > index else { return }

        let quote = quotes[index]
        quoteCell.setup(author: quote.author,
                        body: quote.body)
    }
}
