//
//  FileManagerService.swift
//  MyFIleManager
//
//  Created by eva on 20.08.2024.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol {
    
    var path: String { get set }
    
    func contentsOfDirectory() -> [String]
    func createDirectory(title: String)
    func createFile(img: UIImage, fileName: String)
    func removeContent(index: Int)
    func isFolder(index: Int) -> Bool
    func getFolderName() -> String
}

struct FileManagerService: FileManagerServiceProtocol {
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    func getFolderName() -> String {
        NSString(string: path).lastPathComponent
    }
    
    func contentsOfDirectory() -> [String] {
        var list: [String] = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
        
        if SettingsStore.store.getSortMode() == 0 {
            list = list.sorted{ $0 < $1 }
        } else {
            list = list.sorted{ $0 > $1 }
        }
        
        return list
    }
    
    func createDirectory(title: String) {
        try? FileManager.default.createDirectory(atPath: path + "/" + title, withIntermediateDirectories: true)
    }
    
    func createFile(img: UIImage, fileName: String) {
        let url = URL(filePath: path + "/" + fileName)
        
        try? img.pngData()?.write(to: url)
    }
    
    func removeContent(index: Int) {
        let path = path + "/" + contentsOfDirectory()[index]
        
        try? FileManager.default.removeItem(atPath: path)
    }
    
    func isFolder(index: Int) -> Bool {
        
        let items = contentsOfDirectory()
        
        var objCBool: ObjCBool = .init(false)
        FileManager.default.fileExists(atPath: path + "/" + items[index], isDirectory: &objCBool)
        
        return objCBool.boolValue
    }
}
