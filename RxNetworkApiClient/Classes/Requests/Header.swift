//
// Created by admin on 23.04.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Заголовки, который используются в приложении


public struct Header {

    public let key: String
    public let value: String
}


public extension Header {

    public static func contentJson() -> Header {
        return header("Content-Type", "application/json; charset=utf-8")
    }

    public static func acceptJson() -> Header {
        return header("Accept", "application/json")
    }

    public static func header(_ key: String, _ value: String) -> Header {
        return Header(key: key, value: value)
    }
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
