//
//  SettingsStore.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation

final class SettingsStore {
    static let store = SettingsStore()
    
    func getSortMode() -> Int {
        let defaults = UserDefaults.standard
        let a = defaults.integer(forKey: "sortMode") //тут если нет ключа, то возвращается 0 (случайно нашел:) )
        return a
    }
    
    func setSortMode(sortMode: Int) {
        let defaults = UserDefaults.standard
        defaults.set(sortMode, forKey: "sortMode")
    }
}
