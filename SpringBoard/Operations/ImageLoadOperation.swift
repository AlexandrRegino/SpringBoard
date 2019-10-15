//
//  ImageLoadOperation.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/15/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import UIKit

final class ImageLoadOperation: AbstractAsyncOperation {
    
    weak var imageObject: ImageObject?
    
    init(imageObject: ImageObject) {
        self.imageObject = imageObject
        super.init()
    }
    
    override func main() {
        guard let url = imageObject?.url else {
            imageObject?.state = .error
            state = .finished
            return
        }
        getImageData(from: url) { [weak self] (data, _, error) in
            print("download ended")
            guard let self = self else { return }
            if let data = data, error == nil {
                guard
                    let image = UIImage(data: data),
                    let cacheKey = self.imageObject?.cacheKey,
                    let localUrl = UIImage.fileInDocumentsDirectory(filename: cacheKey)
                    else {
                        self.imageObject?.state = .error
                        self.state = .finished
                        return
                }
                image.saveTo(localUrl)
                self.imageObject?.state = .cashed
            } else {
                self.imageObject?.state = .error
            }
            
            self.state = .finished
        }
    }
}
