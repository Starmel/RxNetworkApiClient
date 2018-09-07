//
// Created by admin on 06.09.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


class ResponseErrorEntity: LocalizedError {

    var errors = [String]()

    var errorDescription: String? {
        return errors.joined()
    }
}
