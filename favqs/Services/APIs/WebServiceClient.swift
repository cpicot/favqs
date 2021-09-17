//
//  WebServiceClient.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import RxSwift
import Alamofire

enum CustomError: Error {
    case defaultError(Error)
    case favqsError(CustomResponseError)
}
extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .defaultError:
            return self.localizedDescription
        case .favqsError(let err):
            return err.message
        }
    }
}

private struct Headers {
    static let contentType = ["Content-Type": "application/json"]

    static let Authorization = ["Authorization": "a5d507733c4c78b3b5ef8dfeeffe96af"]

    static let tokenKey = "User-Token"
}

class WebServiceClient {
    static let baseUrl = "https://favqs.com/api/"
    static let baseHeaders: HTTPHeaders = [
        "Authorization": "Token token=a5d507733c4c78b3b5ef8dfeeffe96af",
        "Content-Type": "application/json"
    ]
    var authHeaders: HTTPHeaders? {
        guard let token = KeychainService.shared.token else {
            return nil
        }

        var headers = WebServiceClient.baseHeaders
        headers.add(name: "User-Token", value: token)
        return headers
    }

    func handleError(responseData: Data?, error: Error) -> CustomError {
        if let data = responseData,
           let sessionError = try? JSONDecoder().decode(CustomResponseError.self, from: data) {
            // Handle custom error
            return CustomError.favqsError(sessionError)
        } else {
            // Handle default error
            return CustomError.defaultError(error)
        }
    }
}
