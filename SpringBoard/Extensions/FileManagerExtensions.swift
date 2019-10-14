//
//  FileManagerExtensions.swift
//  SpringBoard
//
//  Created by Alexandr Regino on 10/14/19.
//  Copyright © 2019 Alexandr Regino. All rights reserved.
//

import Foundation

extension FileManager {
    
    static var documentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static func clearDocumentsDirectory() {
        let fileManager = FileManager.default
        guard
            let documentsDirectory = FileManager.documentsDirectory,
            let filePaths = try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
}
