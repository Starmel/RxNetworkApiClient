//
// Created by admin on 20.01.18.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Оболочка над http запросами.
// https://gist.github.com/AshvinGudaliya/9a458de96c4efda4286491c4d2c0ce24
public typealias QueryField = (String, String?)
public typealias FormDataFields = Dictionary<String, Any?>


open class ApiRequest<ResponseType: Codable>: NetworkRequest {

    open var request: URLRequest {
        var request = URLRequest(url: URL(string: endpoint.host)!)
        request.httpMethod = method?.rawValue.uppercased()

        // Body construction
        if let body = self.body {
            request.httpBody = body.createBody()
        } else {
            // Form data construction
            if (files == nil || files?.isEmpty == true), let formData = formData {
                request.httpBody = formData.compactMap { key, value -> String in
                    return "\(key)=\(value ?? "")"
                }.joined(separator: "&").data(using: .utf8)
            }
            // SET FILES
            if let files = files {
                var body = Data()

                let boundary = UUID().uuidString

                files.forEach { file in
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.name)\"\r\n")
                    body.appendString("Content-Type: \(file.mimeType)\r\n\r\n")
                    body.append(file.data)
                    body.appendString("\r\n")
                }
                if let formData = formData {
                    formData.forEach { key, value in
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.appendString("\(value ?? "null")\r\n")
                    }
                }

                body.appendString("--\(boundary)--\r\n")

                request.setValue("multipart/form-data; boundary=\(boundary)",
                                 forHTTPHeaderField: "Content-Type")
                request.httpBody = body
            }
        }

        if let headers = self.headers {
            request.allHTTPHeaderFields = headers.toMap()
        }

        let endpointPart = endpoint.host
        let pathPart = path ?? ""
        let queryPart = query?.toString() ?? ""
        request.url = URL(string: endpointPart + pathPart + queryPart)!

        return request
    }
    open var responseTimeout: Double = 10
    open var endpoint: ApiEndpoint
    open var query: [QueryField]?
    open var path: String?
    open var formData: FormDataFields?
    open var headers: [Header]?
    open var files: [UploadFile]?
    open var method: HttpMethod?
    open var body: BodyConvertible?


    public init(_ endpoint: ApiEndpoint) {
        self.endpoint = endpoint
    }

    static public func request<ResponseType: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            query: QueryField...) -> ApiRequest<ResponseType> {
        let request = ApiRequest<ResponseType>(endpoint)
        request.path = path
        request.method = method
        request.headers = headers
        request.formData = formData
        request.files = files
        request.body = body
        request.query = query
        return request
    }
}


fileprivate extension Data {

    mutating func appendString(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: false)
        self.append(data!)
    }
}


fileprivate extension Array where Element == QueryField {

    func toString() -> String {
        if !self.isEmpty {
            let flatStringQuery = self.filter({ $0.1?.isEmpty == false })
                    .compactMap({ "\($0)=\($1!)" })
                    .joined(separator: "&")
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return "?\(flatStringQuery)"
        }
        return ""
    }
}
