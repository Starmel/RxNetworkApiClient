//
// Created by admin on 20.01.18.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Служит для модификации запроса перед отправкой и выполнения логики после получения ответа.
public protocol Interceptor: class {

    func prepare<T: Codable>(request: ApiRequest<T>)

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse)
}
