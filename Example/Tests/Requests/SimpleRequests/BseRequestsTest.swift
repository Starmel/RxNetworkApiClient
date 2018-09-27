//
// Created by admin on 09.09.2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxNetworkApiClient


class BaseRequestsTest: XCTestCase {

    private static let POSTMAN_API_TEST_URL = "https://a5d30f77-b2fd-48a1-9f6d-286987e91db4.mock.pstmn.io/"


    func getApiClient() -> ApiClient {
        return ApiClientImp.defaultInstance(host: BaseRequestsTest.POSTMAN_API_TEST_URL)
    }
}
