//
//  ApiRouter.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case getUserDetails(login: String)
    case favourites(login: String, page: Int)
    case signIn(credantials: FavqsSession)

    func asURLRequest() throws -> URLRequest {
        let url = try MyWebServiceClient.baseUrl.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        urlRequest.httpMethod = method.rawValue

        urlRequest.headers = headers

        return try encoding.encode(urlRequest, with: parameters)
    }

    private var headers: HTTPHeaders {
        switch self {
        // TODO: Handle authenticated call seession error
        case .getUserDetails,
             .favourites:
            return MyWebServiceClient.authHeaders ?? MyWebServiceClient.baseHeaders
        case .signIn:
            return MyWebServiceClient.baseHeaders
        }
    }

    private var path: String {
        switch self {
        case .getUserDetails(let login):
            return "users/\(login)"
        case .favourites:
            return "quotes"
        case .signIn:
            return "session"
        }
    }

    private var encoding: ParameterEncoding {
        switch self {
        case .getUserDetails,
             .favourites:
            return URLEncoding.default
        case .signIn:
            return JSONEncoding.default
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .getUserDetails,
             .favourites:
            return .get
        case .signIn:
            return .post
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .signIn(let credantials):
            return credantials.asDictionary
        case .getUserDetails:
            return nil
        case .favourites(let login, let page):
            return ["filter": login,
                    "type": "user",
                    "page": "\(page)"]

            // uncomment to try pagination
//            return ["page": "\(page)"]
        }
    }

}
