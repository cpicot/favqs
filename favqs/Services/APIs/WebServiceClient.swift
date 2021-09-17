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

protocol WebServiceClient {
    func getUserDetails(login: String) -> Observable<UserResponse>
    func getUserFavourites(login: String, page: Int) -> Observable<QuotesResponse>
    func createSession(credantials: FavqsSession) -> Observable<SessionResponse>
}

class MyWebServiceClient {
    static let baseUrl = "https://favqs.com/api/"
    static let baseHeaders: HTTPHeaders = [
        "Authorization": "Token token=a5d507733c4c78b3b5ef8dfeeffe96af",
        "Content-Type": "application/json"
    ]
    static var authHeaders: HTTPHeaders? {
        guard let token = KeychainService.shared.token else {
            return nil
        }

        var headers = MyWebServiceClient.baseHeaders
        headers.add(name: "User-Token", value: token)
        return headers
    }
}

private extension MyWebServiceClient {
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    if let data = response.data,
                       let sessionError = try? JSONDecoder().decode(CustomResponseError.self, from: data) {
                        // Handle custom error
                        observer.onError(CustomError.favqsError(sessionError))
                    } else {
                        // Handle default error
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension MyWebServiceClient: WebServiceClient {
    func getUserDetails(login: String) -> Observable<UserResponse> {
        return request(ApiRouter.getUserDetails(login: login))
    }

    func getUserFavourites(login: String, page: Int) -> Observable<QuotesResponse> {
        return request(ApiRouter.favourites(login: login, page: page))
    }

    func createSession(credantials: FavqsSession) -> Observable<SessionResponse> {
        return request(ApiRouter.signIn(credantials: credantials))
    }
}
