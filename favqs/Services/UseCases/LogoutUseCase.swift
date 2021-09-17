//
//  LogoutUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

class LogoutUseCase {
    func execute() -> Single<Bool> {
        // TODO: Call WS destroy session
        KeychainService.shared.resetCredentiels()
        return Single.just(true)
    }
}
