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
    
    func setup(state: ImageState, cacheKey: String?) {
        switch state {
        case .loading:
            imageView.isHidden = true
            activityIndicator.startAnimating()
        case .cashed:
            guard
                let cacheKey = cacheKey,
                let localUrl = UIImage.fileInDocumentsDirectory(filename: cacheKey),
                let cachedImage = UIImage.loadImageFrom(localUrl)
                else {
                    setImage(UIImage(named: "empty"))
                    return
            }
            setImage(cachedImage)
        case .notSet, .empty:
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
    
}
