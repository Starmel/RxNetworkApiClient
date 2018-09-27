import XCTest
import RxNetworkApiClient
import RxSwift


class SimpleGetRequestsTest: BaseRequestsTest {

    func testGet200() {
        let exp = expectation(description: "Get 200")
        let apiClient = getApiClient()

        apiClient.execute(request: .request(path: "get_test_response_200", method: .get))
                .subscribe(onSuccess: { (response: ApiResultEntity) in
                    exp.fulfill()
                }, onError: { error in
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
                })

        waitForExpectations(timeout: 10)
    }

    func testGet500() {
        let exp = expectation(description: "Get 500")
        let apiClient = getApiClient()

        apiClient.execute(request: .request(path: "get_test_response_200", method: .get))
                .subscribe(onSuccess: { (response: ApiResultEntity) in
                    XCTFail("Wrong")
                }, onError: { error in
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
                })

        waitForExpectations(timeout: 10)
    }
}
