//
// Created by admin on 06.08.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


public struct UploadFile {

    public let name: String
    public let data: Data
    public let mimeType: String


    public init(_ name: String, _ data: Data, _ mimeType: String) {
        self.name = name
        self.data = data
        self.mimeType = mimeType
    }
}
