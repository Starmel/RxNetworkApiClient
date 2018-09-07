//
// Created by admin on 10.08.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


public protocol JsonBodyConvertible: BodyConvertible, Codable {
}


public extension JsonBodyConvertible {

    public func createBody() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
