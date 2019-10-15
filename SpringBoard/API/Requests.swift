//
//  Requests.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/15/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import Foundation

func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    print("download started")
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
