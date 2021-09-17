//
//  LoginUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Foundation

final class LoginUseCase {
    private let api = SessionAPI()

    func execute(email: String,
                 password: String,
                 completion: @escaping (Bool, CustomError?) -> Void) {
        let credentials = FavqsSession(user: User(login: email, password: password))
        api.createSession(credantials: credentials, completion: { session, error in
            if let session = session {
                KeychainService.shared.updateCredantials(session: session)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        })
    }
}
