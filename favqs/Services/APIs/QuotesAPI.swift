//
//  FavouritesAPI.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import Alamofire
import RxSwift

class QuotesAPI: WebServiceClient {
    var url: URL? {
        var url = URL(string: WebServiceClient.baseUrl)
        url?.appendPathComponent("quotes")
        return url
    }

    func favourites(login: String,
                    completion: @escaping (QuotesResponse?, CustomError?) -> Void) {
        guard let favUrl = url,
              let headers = self.authHeaders,
              var urlComponents = URLComponents(url: favUrl, resolvingAgainstBaseURL: false)
        else { return }

        urlComponents.queryItems = [URLQueryItem(name: "filter", value: login),
                               URLQueryItem(name: "type", value: "user")]

        guard let favouriteUrl = urlComponents.url
        else { return }

        var request = URLRequest(url: favouriteUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.headers = headers

        AF.request(request).responseDecodable(of: QuotesResponse.self) { [weak self] response in

            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                let customError = self?.handleError(responseData: response.data, error: error)
                completion(nil, customError)
            }
        }
    }
}
