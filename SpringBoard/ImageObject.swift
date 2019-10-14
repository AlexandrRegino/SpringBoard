//
//  ImageObject.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/14/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import Foundation

final class ImageObject {
    var url = URL(string: "http://lorempixel.com/200/200/")
    var cacheKey: String?
    var status: ImageStatus
    
    init(cacheKey: String?, status: ImageStatus = .notSet) {
        self.cacheKey = cacheKey
        self.status = status
    }
}

enum ImageStatus {
    case notSet
    case loading
    case cashed
    case empty
    case error
}
