//
//  UserResponse.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let login: String
    let picURL: String
    let publicFavoritesCount, following, followers: Int
    let pro: Bool
    let accountDetails: AccountDetails

    enum CodingKeys: String, CodingKey {
        case login
        case picURL = "pic_url"
        case publicFavoritesCount = "public_favorites_count"
        case following, followers, pro
        case accountDetails = "account_details"
    }
}

// MARK: - AccountDetails
struct AccountDetails: Codable {
    let email: String
    let privateFavoritesCount: Int

    enum CodingKeys: String, CodingKey {
        case email
        case privateFavoritesCount = "private_favorites_count"
    }
}
