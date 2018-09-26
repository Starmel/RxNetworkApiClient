//
// Created by admin on 23.04.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Заголовки, который используются в приложении


public struct Header {

    public let key: String
    public let value: String


    public init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}


public extension Header {

    public static let contentJson = Header("Content-Type", "application/json; charset=utf-8")
    public static let acceptJson = Header("Accept", "application/json")
}


public extension Array where Element == Header {

    public func toMap() -> [String: String] {
        var map: [String: String] = [:]
        forEach { header in
            map[header.key] = header.value
        }
        return map
    }
}
