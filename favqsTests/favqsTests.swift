//
//  favqsTests.swift
//  favqsTests
//
//  Created by Clement Picot on 16/09/2021.
//

import XCTest
import RxSwift

@testable import favqs

class MockedWebServiceClient: WebServiceClient {
    func getUserFavourites(login: String, page: Int) -> Observable<QuotesResponse> {
        Observable.just(QuotesResponse(page: 0, lastPage: true, quotes: []))
    }

    func getUserDetails(login: String) -> Observable<UserResponse> {
        return Observable.just(UserResponse(login: "test",
                                            picURL: "",
                                            publicFavoritesCount: 4,
                                            following: 4,
                                            followers: 4,
                                            pro: false,
                                            accountDetails: AccountDetails(email: "test@test.test",
                                                                           privateFavoritesCount: 0)))
    }

    func createSession(credantials: FavqsSession) -> Observable<SessionResponse> {
        Observable.just(SessionResponse(userToken: "AZERTYUIO",
                                        login: "test",
                                        email: "test@test.test"))
    }

}

class favqsTests: XCTestCase {

    let disposeBag: DisposeBag = DisposeBag()
    let webServiceClient: WebServiceClient = MockedWebServiceClient()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        LoginUseCase(client: webServiceClient)
            .execute(email: "email", password: "pass")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                assert(true)
            }, onFailure: { _ in
                assert(false)
            })
            .disposed(by: disposeBag)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
