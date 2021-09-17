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
    private var hasMore = false
    private var currentPage: Int = 0

    weak var delegate: ViewModelDelegate?

    func refreshContent() {
        userUseCase.execute { [weak self] user in
            self?.currentUser = user
        }
        favouritesUseCase.execute { [weak self] response in
            guard let strongSelf = self,
                  let response = response else { return }

            strongSelf.quotes.append(contentsOf: response.quotes)
            strongSelf.currentPage = response.page
            strongSelf.hasMore = response.lastPage
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
