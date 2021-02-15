//
// Created by admin on 26.06.2018.
// Copyright (c) 2018 WebAnt. All rights reserved.
//

import Foundation


/// Типы http запросов, которые могут совершаться.
public enum HttpMethod: String {
    case get, post, put, patch, delete, copy, head, options, link, unlink, purge, lock, unlock, propfind, view
}
