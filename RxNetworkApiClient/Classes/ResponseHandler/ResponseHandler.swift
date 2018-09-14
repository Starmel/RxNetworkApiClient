//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import RxSwift


/// Занимается обработкой приходящих ответов от сервера или ошибок во время отправки запроса.
public protocol ResponseHandler: class {

    /// Обработать ответ.
    ///
    /// - Parameters:
    ///   - observer: Наблюдатель, который ждет обработанного ответа.
    ///   - request: Запрос, который был отправлен.
    ///   - response: Ответ, полученный от сервера.
    /// - Returns: Был ли ответ обработан.
    func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                            request: ApiRequest<T>,
                            response: NetworkResponse) -> Bool
}
