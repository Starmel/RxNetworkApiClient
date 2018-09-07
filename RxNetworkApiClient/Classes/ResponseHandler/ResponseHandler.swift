//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import RxSwift


/// Занимается обработкой приходящих ответов от сервера или ошибок во время отправки запроса.
public protocol ResponseHandler {

    /// Обработать ответ.
    ///
    /// - Parameters:
    ///   - observer: Наблюдатель, который ждет обработанного ответа.
    ///   - response: Ответ, полученный от сервера.
    /// - Returns: Был ли ответ обработан.
    func handle<T: Codable>(observer: SingleObserver<T>, response: NetworkResponse) -> Bool
}
