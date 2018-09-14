//
// Created by admin on 20.01.18.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

public typealias NetworkResponse = (data: Data?, urlResponse: URLResponse?, error: Error?)
public typealias SingleObserver<T> = (SingleEvent<T>) -> ()


/// Клиент для выполнения сетевых api запросов.
public protocol ApiClient: class {

    /// - Parameter request: Запрос, который нужно выполнить
    /// - Returns: Объект, который нужно вернуть при успешном завершении.
    var interceptors: [Interceptor] { set get }
    var responseHandlersQueue: [ResponseHandler] { set get }
    func execute<T: Codable>(request: ApiRequest<T>) -> Single<T>
}


public protocol URLSessionProtocol {

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}


extension URLSession: URLSessionProtocol {
}


public class ApiClientImp: ApiClient {

    private let urlSession: URLSessionProtocol
    public var timeoutScheduler = MainScheduler.instance
    public var dispatchQueue = SerialDispatchQueueScheduler(qos: .default,
                                                            internalSerialQueueName: "network_queue")

    public var interceptors = [Interceptor]()
    public var responseHandlersQueue = [ResponseHandler]() // При добавлением обработчиков в список, важно учитывать порядок, в котором они будут вызываться


    public init(urlSessionConfiguration: URLSessionConfiguration,
                completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration,
                                delegate: nil,
                                delegateQueue: completionHandlerQueue)
    }

    public init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    public func execute<T>(request: ApiRequest<T>) -> Single<T> {
        return Single.create { (observer: @escaping (SingleEvent<T>) -> ()) in
                    self.prepare(request)

                    let dataTask: URLSessionDataTask = self.urlSession
                            .dataTask(with: request.request) { (data, response, error) in

                        self.preHandle(request, (data, response, error))
                        var isHandled = false
                        for handler in self.responseHandlersQueue {
                            if isHandled {
                                break
                            }
                            isHandled = handler.handle(observer: observer,
                                                       request: request,
                                                       response: (data, response, error))
                        }
                        if !isHandled {
                            let errorEntity = ResponseErrorEntity(response)
                            errorEntity.errors.append(
                                    "Внутренняя ошибка приложения: не найдет обработчик ответа от сервера")
                            observer(.error(errorEntity))
                        }
                    }
                    dataTask.resume()
                    return Disposables.create {
                        dataTask.cancel()
                    }
                }
                .subscribeOn(dispatchQueue)
                .observeOn(dispatchQueue)
                .timeout(request.responseTimeout, scheduler: timeoutScheduler)
                .do(onError: { error in print("network error:", error.localizedDescription) })
    }

    /// Вызывается перед тем, как обработается ответ от сервера.
    ///
    /// - Parameter response: Полученный ответ.
    private func preHandle<T: Codable>(_ request: ApiRequest<T>, _ response: NetworkResponse) {
        interceptors.forEach { interceptor in
            interceptor.handle(request: request, response: response)
        }
    }

    /// Вызывается перед тем, как будет отправлен запрос к серверу.
    ///
    /// - Parameter request: Запрос, который отправляется.
    private func prepare<T>(_ request: ApiRequest<T>) {
        interceptors.forEach { interceptor in
            interceptor.prepare(request: request)
        }
    }

    public static func defaultInstance(host: String) -> ApiClientImp {
        ApiEndpoint.baseEndpoint = ApiEndpoint(host)
        let apiClient = ApiClientImp(urlSession: URLSession.shared)
        apiClient.interceptors.append(LoggingInterceptor())
        apiClient.responseHandlersQueue.append(JsonResponseHandler())
        return apiClient
    }
}
