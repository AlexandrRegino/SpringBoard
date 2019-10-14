//
//  CollectionViewCell.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/14/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 7
        activityIndicator.stopAnimating()
        imageView.isHidden = true
    }
    
    func setup(imageObject: ImageObject, completion: @escaping () -> ()) {
        switch imageObject.status {
        case .notSet:
            imageView.isHidden = true
            activityIndicator.startAnimating()
            guard let url = imageObject.url else {
                imageObject.status = .error
                setImage(UIImage(named: "empty"))
                return
            }
            imageObject.status = .loading
            getImageData(from: url) { (data, _, error) in
                print("download ended")
                if let data = data, error == nil {
                    guard
                        let image = UIImage(data: data),
                        let cacheKey = imageObject.cacheKey,
                        let localUrl = UIImage.fileInDocumentsDirectory(filename: cacheKey)
                        else {
                            imageObject.status = .error
                            completion()
                            return
                    }
                    image.saveTo(localUrl)
                    imageObject.status = .cashed
                    completion()
                } else {
                    imageObject.status = .error
                    completion()
                }
            }
        case .loading:
            imageView.isHidden = true
            activityIndicator.startAnimating()
        case .cashed:
            guard
                let cacheKey = imageObject.cacheKey,
                let localUrl = UIImage.fileInDocumentsDirectory(filename: cacheKey),
                let cachedImage = UIImage.loadImageFrom(localUrl)
                else {
                    setImage(UIImage(named: "empty"))
                    return
            }
            setImage(cachedImage)
        case .empty:
            activityIndicator.stopAnimating()
            imageView.isHidden = true
        case .error:
            setImage(UIImage(named: "empty"))
        }
    }
    
    private func setImage(_ image: UIImage?) {
        imageView.image = image
        activityIndicator.stopAnimating()
        imageView.isHidden = false
    }
    
    private func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            print("download started")
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }
    
}
