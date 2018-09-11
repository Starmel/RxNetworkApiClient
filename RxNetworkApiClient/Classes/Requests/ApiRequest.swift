//
// Created by admin on 20.01.18.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Оболочка над http запросами.
// https://gist.github.com/AshvinGudaliya/9a458de96c4efda4286491c4d2c0ce24
public typealias QueryField = (String, String?)
public typealias FormDataFields = Dictionary<String, Any?>


public class ApiRequest<ResponseType: Codable>: NetworkRequest {

    public var request: URLRequest
    public var responseTimeout: Double = 10
    private var endpoint: ApiEndpoint
    private var query: [QueryField]? = nil
    private var path: String? = nil
    private var formData: FormDataFields? = nil
    private var headers: [Header]? = nil
    private var files: [UploadFile]? = nil


    public init(method: HttpMethod, endpoint: ApiEndpoint) {
        self.endpoint = endpoint
        request = URLRequest(url: URL(string: endpoint.host)!)
        request.httpMethod = method.rawValue
        updateUrl()
    }

    public func setQuery(_ query: QueryField...) {
        self.query = query
        updateUrl()
    }

    public func setPath(_ path: String) {
        self.path = path
        updateUrl()
    }

    public func setQuery(_ query: [QueryField]) {
        self.query = query
        updateUrl()
    }

    public func setFormDataParams(params: FormDataFields) {
        self.formData = params
        updateFormData()
    }

    public func setHeaders(_ headers: [Header]) {
        self.headers = headers
        updateHeaders()
    }

    public func setFiles(_ files: [UploadFile]) {
        self.files = files
        updateFormData()
    }

    public func setBody(_ body: BodyConvertible) {
        request.httpBody = body.createBody()
    }

    public func updateFormData() { // FORM DATA
        if files?.isEmpty == true, let formData = formData {
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

    public func updateHeaders() { // SET HEADERS
        if let headers = headers {
            request.allHTTPHeaderFields = headers.toMap()
        }
    }

    public func updateUrl() { // Set path + query
        let endpointPart = endpoint.host
        let pathPart = path ?? ""
        let queryPart = query?.toString() ?? ""
        request.url = URL(string: endpointPart + pathPart + queryPart)!
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
        let request = ApiRequest<ResponseType>(method: method, endpoint: endpoint)

        if path != nil {
            request.setPath(path!)
        }
        if headers != nil {
            request.setHeaders(headers!)
        }
        if formData != nil {
            request.setFormDataParams(params: formData!)
        }
        if files != nil {
            request.setFiles(files!)
        }
        if !query.isEmpty {
            request.setQuery(query)
        }
        if body != nil {
            request.setBody(body!)
        }
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
        let flatStringQuery = self.filter({ $0.1?.isEmpty == false })
                .compactMap({ "\($0)=\($1!)" })
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return "?\(flatStringQuery)"
    }
}