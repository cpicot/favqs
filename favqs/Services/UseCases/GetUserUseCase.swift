//
//  GetUserUseCase.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift

final class GetUserUseCase {
    private let api = UserAPI()

    func execute(login: String? = KeychainService.shared.login,
                 completion: @escaping (UserResponse?) -> Void) {
        guard let login = login else { return }
        
        api.userDetails(login: login) { user, _ in
            completion(user)
        }
    }

}
