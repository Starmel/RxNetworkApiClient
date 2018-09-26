//
// Created by admin on 07.09.2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxNetworkApiClient


extension ApiRequest {

    static func todoList() -> ApiRequest {
        return request(path: "/todos", method: .get)
    }

    static func crate() -> ApiRequest {
        return request(path: "/todos", method: .post, formData: ["data": "ok"])
    }
}
