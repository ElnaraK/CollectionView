//
//  FileService.swift
//  lab5
//
//  Created by Elnara  on 4/28/20.
//  Copyright © 2020 Elnara . All rights reserved.
//

import Foundation

class FileService {
    
    static let shared = FileService()
    
    func downloadFiles(_ documentsDirectoryURL: URL) -> [URL] {
        let filesList = contentsOf(documentsDirectoryURL)
        return filesList
    }
    
    func contentsOf(_ folder: URL) -> [URL] {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)

            let urls = contents.map { return folder.appendingPathComponent($0) }
            return urls
        } catch {
            print("error")
            return []
        }
    }
    
}
