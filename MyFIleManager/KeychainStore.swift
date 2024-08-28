//
//  KeychainStore.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation
import KeychainAccess

final class KeychainStore {
    static let store = KeychainStore()
    
    private var name: String {
        return "ru.eva.llee.MyFIleManager"
    }
    
    func getPass() -> String? {
        let keychain = Keychain(service: name)

        let pass = try? keychain.get("password")
        
        return pass
    }
    
    func setPass(password: String) {
        let keychain = Keychain(service: name)
        
        try? keychain.set(password, key: "password")
    }
    
    func removePass() {
        let keychain = Keychain(service: name)
        
        do {
            try keychain.remove("password")
        } catch let error {
            print("error: \(error)")
        }
    }
}
