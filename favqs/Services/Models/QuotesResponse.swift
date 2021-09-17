//
//  QuotesResponse.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import Foundation


// MARK: - QuotesResponse
struct QuotesResponse: Codable {
    let page: Int
    let lastPage: Bool
    let quotes: [Quote]

    enum CodingKeys: String, CodingKey {
        case page
        case lastPage = "last_page"
        case quotes
    }
}

// MARK: - Quote
struct Quote: Codable {
    let ident: Int
    let dialogue, quotePrivate: Bool
    let tags: [String]
    let url: String
    let favoritesCount, upvotesCount, downvotesCount: Int
    let author, authorPermalink, body: String
    let userDetails: UserDetails

    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case dialogue
        case quotePrivate = "private"
        case tags, url
        case favoritesCount = "favorites_count"
        case upvotesCount = "upvotes_count"
        case downvotesCount = "downvotes_count"
        case author
        case authorPermalink = "author_permalink"
        case body
        case userDetails = "user_details"
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let favorite, upvote, downvote, hidden: Bool
}
