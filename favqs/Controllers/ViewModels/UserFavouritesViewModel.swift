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
    private var userUseCase: GetUserUseCase
    private var favouritesUseCase: GetFavouritesUseCase
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

    init(webServiceClient: WebServiceClient) {
        userUseCase = GetUserUseCase(client: webServiceClient)
        favouritesUseCase = GetFavouritesUseCase(client: webServiceClient)
    }

    func refreshUserContent() {
        userUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] userResponse in
                self?.currentUser = userResponse
            })
            .disposed(by: disposeBag)
    }

    func refreshFavouriteContent() {
        guard hasMore else { return }

        favouritesUseCase.execute(page: nextPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let strongSelf = self,
                      let response = response else { return }

                strongSelf.quotes.append(contentsOf: response.quotes)
                strongSelf.nextPage = response.page + 1
                strongSelf.hasMore = !response.lastPage
            }, onFailure: { error in
                // TODO: handle errors
                if let customeError = error as? CustomError {
                    print(customeError.description)
                } else {
                    print(error)
                }
            })
            .disposed(by: disposeBag)
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
