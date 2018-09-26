//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import RxSwift
import SwiftyJSON


/// Возвращает требуемый объект или JSON объект, если ответ успешный.
open class JsonResponseHandler: ResponseHandler {

    public init() {
    }

    private let decoder = JSONDecoder()

    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        if let data = response.data {
            do {
                if T.self == JSON.self {
                    let json = try JSON(data: data)
                    observer(.success(json as! T))
                } else if T.self == Data.self {
                    observer(.success(data as! T))
                } else {
                    let result = try decoder.decode(T.self, from: data)
                    observer(.success(result))
                }
            } catch {
                observer(.error(error))
            }
            return true
        }
        return false
    }
}
