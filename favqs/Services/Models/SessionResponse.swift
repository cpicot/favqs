//
//  SessionResponse.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}

// TODO: split these structs in multiples files

// MARK: - SessionResponse
struct SessionResponse: Codable {
    let userToken, login, email: String

    enum CodingKeys: String, CodingKey {
        case userToken = "User-Token"
        case login, email
    }
}

// MARK: - Session
struct FavqsSession: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let login, password: String
}

// MARK: - SessionResponseError
struct CustomResponseError: Codable {
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message
    }
}
