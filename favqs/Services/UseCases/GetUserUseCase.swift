//
//  GetUserUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

final class GetUserUseCase {
    private let webServiceClient: WebServiceClient

    init(client: WebServiceClient) {
        webServiceClient = client
    }

    func execute(login: String? = KeychainService.shared.login) -> Single<UserResponse?> {
        guard let login = login else { return Single.just(nil) }

        return webServiceClient.getUserDetails(login: login)
            .asSingle()
            .flatMap { userResponse -> Single<UserResponse?> in
                // In case we use a data base (ex realm), we store userResponse here
                // and return a empty single (to stop loading for example)
                // (assuming realm is observed in view model)
                return Single.just(userResponse)
            }
    }

}
