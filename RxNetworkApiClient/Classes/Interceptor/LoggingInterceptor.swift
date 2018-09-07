//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Позволяет логировать в консоль совершаемые http запросы.
public class LoggingInterceptor: Interceptor {

    public init(){

    }

    public func prepare(request: inout URLRequest) {
        var parameters = ""
        if let params = request.httpBody {
            let body = String(data: params, encoding: .utf8)
                    ?? String(data: params, encoding: .ascii)
                    ?? "\(params)"
            parameters = "Parameters: \(body)"
        }

        request.allHTTPHeaderFields?.forEach { key, value in
            print(">>> Header: '\(key)' - '\(value)'")
        }
        print(">>> \(request.url!.absoluteString) [\(request.httpMethod ?? "NULL")] \(parameters)\n")
    }

    public func handle(response: NetworkResponse) {
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
        switch code {
            case 200:
                return "👌"
            case 500:
                return "💥"
            default:
                return "⚠️"
        }
    }
}
