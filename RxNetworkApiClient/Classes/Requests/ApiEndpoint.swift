//
// Created by admin on 04.04.18.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Адреса, к которым могут создаваться http запросы.
public struct ApiEndpoint {

    public static var baseEndpoint: ApiEndpoint!
    public let host: String
    
    
    public init(_ host: String){
        self.host = host
    }
}
