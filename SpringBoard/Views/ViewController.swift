//
//  ViewController.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/14/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageNumberLabel: UILabel!
    
    private let numberOfSections = 7
    private let numberOfRows = 10
    private let inset: CGFloat = 2
    
    var images: [ImageObject] = []
    
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var collectionViewWidth: CGFloat!
    private let loadImageQueue = OperationQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageQueue.maxConcurrentOperationCount = 10
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        reloadImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewWidth = collectionView.frame.size.width
        cellWidth = (collectionViewWidth - inset * 7) / CGFloat(numberOfSections)
        cellHeight = (collectionView.bounds.size.height - inset * 10) / CGFloat(numberOfRows)
    }
    
    private func reloadImages() {
        images = []
        FileManager.clearDocumentsDirectory()
        let numberItemsInPage = numberOfSections * numberOfRows * 2
        for index in 0..<numberItemsInPage {
            images.append(ImageObject(cacheKey: "\(index)"))
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        loadImageQueue.cancelAllOperations()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        reloadImages()
        collectionView.reloadData()
    }
    
    @IBAction func addAction(_ sender: Any) {
        if let indexEmpty = images.firstIndex(where: { $0.state == .empty }) {
            images[indexEmpty] = ImageObject(cacheKey: "\(indexEmpty)")
            let section = indexEmpty/numberOfRows
            let item = indexEmpty - section * numberOfRows
            collectionView.reloadItems(at: [IndexPath(item: item, section: section)])
        } else {
            images.append(ImageObject(cacheKey: "\(images.count)"))
            let numbersOfElements = numberOfSections * numberOfRows
            if images.count % numbersOfElements > 0 {
                let emptyCount = numbersOfElements - images.count % numbersOfElements
                for _ in 0..<emptyCount {
                    images.append(ImageObject(cacheKey: nil, state: .empty))
                }
            }
            collectionView.reloadData()
        }
        
        let section = collectionView.numberOfSections - 1;
        let item = collectionView.numberOfItems(inSection: section) - 1
        collectionView.scrollToItem(at: IndexPath(item: item, section: section), at: .right, animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(round(scrollView.contentOffset.x / collectionViewWidth))
        pageNumberLabel.text = "\(currentIndex + 1)"
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfObjects = images.count
        if numberOfObjects - section * numberOfRows >= numberOfRows {
            return numberOfRows
        } else {
            return numberOfObjects % numberOfRows
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfObjects = images.count
        var numberOfSections = (numberOfObjects / numberOfRows);
        if numberOfObjects % numberOfRows > 0 {
            numberOfSections += 1
        }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell
        let index = indexPath.section * numberOfRows + indexPath.row
        let imageObject = images[index]
        if imageObject.state == .notSet {
            imageObject.state = .loading
            let operationLoad = ImageLoadOperation(imageObject: imageObject)
            operationLoad.completionBlock = {
                OperationQueue.main.addOperation {
                    if !operationLoad.isCancelled {
                        collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
            loadImageQueue.addOperation(operationLoad)
        }
        cell?.setup(state: imageObject.state, cacheKey: imageObject.cacheKey)
        return cell ?? UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset / 2, bottom: inset, right: inset / 2);
    }
}

