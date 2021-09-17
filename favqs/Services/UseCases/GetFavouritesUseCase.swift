//
//  GetFavouritesUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Foundation

final class GetFavouritesUseCase {
    private let api = QuotesAPI()

    func execute(login: String? = KeychainService.shared.login,
                 completion: @escaping (QuotesResponse?) -> Void) {
        guard let login = login else { return }

        api.favourites(login: login) { quotesResponse, _ in
            completion(quotesResponse)
        }
    }
}