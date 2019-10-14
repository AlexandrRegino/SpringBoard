//
//  UIImageExtensions.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/14/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import UIKit

extension UIImage {

    static func fileInDocumentsDirectory(filename: String) -> URL? {
        return FileManager.documentsDirectory?.appendingPathComponent(filename)
    }
    
    func saveTo(_ path: URL) {
        if let data = jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: path)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }

    static func loadImageFrom(_ path: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: path)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

}
