//
//  GetFavouritesUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

final class GetFavouritesUseCase {
    private let webServiceClient: WebServiceClient

    init(client: WebServiceClient) {
        webServiceClient = client
    }
    
    func execute(login: String? = KeychainService.shared.login,
                 page: Int) -> Single<QuotesResponse?> {
        guard let login = login else { return Single.just(nil) }

        return webServiceClient.getUserFavourites(login: login, page: page)
            .asSingle()
            .flatMap { response -> Single<QuotesResponse?> in
                // In case we use a data base (ex realm), we store response here
                // and return a empty single (to stop loading for example)
                // (assuming realm is observed in view model)
                return Single.just(response)
            }
    }
}
