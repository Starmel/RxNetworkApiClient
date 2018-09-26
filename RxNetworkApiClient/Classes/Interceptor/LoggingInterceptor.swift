//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Позволяет логировать в консоль совершаемые http запросы.
open class LoggingInterceptor: Interceptor {

    public init() {
    }

    public func prepare<T: Codable>(request: ApiRequest<T>) {
        let urlRequest = request.request
        var parameters = ""
        if let params = urlRequest.httpBody {
            let body = String(data: params, encoding: .utf8)
                    ?? String(data: params, encoding: .ascii)
                    ?? "\(params)"
            parameters = "Parameters: \(body)"
        }

        urlRequest.allHTTPHeaderFields?.forEach { key, value in
            print(">>> Header: '\(key)' - '\(value)'")
        }
        print(">>> \(urlRequest.url!.absoluteString) [\(urlRequest.httpMethod ?? "NULL")] \(parameters)\n")
    }


    public func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        if let urlResponse = response.urlResponse {
            var responseBody = ""
            if let data = response.data {
                responseBody = "Body: \(String(data: data, encoding: .utf8)!)"
            }
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                print("<<< \(urlResponse.url!.absoluteString) \(responseBody)")
                return
            }
            let statusEmoji = getStatusEmoji(httpUrlResponse.statusCode)

            print("<<< \(urlResponse.url!.relativeString)")
            print("<<< Status code: (\(httpUrlResponse.statusCode)) \(statusEmoji)")
            print("<<< Body: \(responseBody)\n")
        } else {
            print("<<< nil response")
        }
    }

    private func getStatusEmoji(_ code: Int) -> String {
        if (200...300).contains(code) {
            return "👌"
        } else if (400...500).contains(code) {
            return "🤔"
        } else if (500...600).contains(code) {
            return "💥"
        }
        return ""
    }
}
