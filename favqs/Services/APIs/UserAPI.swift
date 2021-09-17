//
//  UserAPI.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Alamofire
import RxSwift

class UserAPI: WebServiceClient {
    var userUrl: URL? {
        var url = URL(string: WebServiceClient.baseUrl)
        url?.appendPathComponent("users")
        return url
    }

    func userDetails(login: String, completion: @escaping (UserResponse?, Error?) -> Void) {
        var url = userUrl
        url?.appendPathComponent(login)
        guard let userUrl = url,
              let headers = self.authHeaders else { return }

        var request = URLRequest(url: userUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.headers = headers

        AF.request(request).response {
            (response) in
            if let data = response.data,
               let user = try? JSONDecoder().decode(UserResponse.self, from: data) {
                completion(user, nil)
            } else {
                completion(nil, nil) // handle errors
            }
        }
    }
}
