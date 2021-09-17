//
//  SessionAPI.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Alamofire
import RxSwift

class SessionAPI: WebServiceClient {
    var sessionUrl: URL? {
        var url = URL(string: WebServiceClient.baseUrl)
        url?.appendPathComponent("session")
        return url
    }

    func createSession(credantials: FavqsSession,
                       completion: @escaping (SessionResponse?, CustomError?) -> Void) {
        guard let url = sessionUrl,
              let data = try? JSONEncoder().encode(credantials)
        else {
            assert(false, "bad session API values")
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.headers = WebServiceClient.baseHeaders
        request.httpBody = data

        AF.request(request).responseDecodable(of: SessionResponse.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                let customError = self?.handleError(responseData: response.data,
                                                    error: error)
                completion(nil, customError)
            }

        }
    }
}
