//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


///// Добавляет к каждому запросу заголовок авторизации, если есть токен авторизации.
//public class AuthInterceptor: Interceptor {
//
//    private let settings: Settings
//
//
//    public init(_ settings: Settings) {
//        self.settings = settings
//    }
//
//    public func prepare(request: inout URLRequest) {
//        let authHeader = request.allHTTPHeaderFields?["Authorization"]
//        if authHeader == nil, let auth = settings.authToken {
//            request.addValue("Bearer \(auth.token)", forHTTPHeaderField: "Authorization")
//        }
//    }
//
//    public func handle(response: NetworkResponse) {
//        // empty
//    }
//}
