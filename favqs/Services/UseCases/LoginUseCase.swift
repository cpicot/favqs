//
//  LoginUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

final class LoginUseCase {
    private let webServiceClient: WebServiceClient

    init(client: WebServiceClient) {
        webServiceClient = client
    }

    func execute(email: String,
                 password: String) -> Single<Bool> {
        let credentials = FavqsSession(user: User(login: email, password: password))
        return webServiceClient.createSession(credantials: credentials)
            .asSingle()
            .flatMap { response -> Single<Bool> in
                KeychainService.shared.updateCredantials(session: response)
                return Single.just(true)
            }
    }
}
