//
// Created by admin on 10.08.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


public protocol JsonBodyConvertible: BodyConvertible, Codable {

    var jsonEncoder: JSONEncoder { get }
}


public extension JsonBodyConvertible {

    public var jsonEncoder: JSONEncoder {
        return JSONEncoder()
    }

    public func createBody() -> Data {
        return try! jsonEncoder.encode(self)
    }
}
