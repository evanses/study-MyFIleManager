//
//  LoginViewModel.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation
import UIKit

final class LoginViewModel {
    
    func isPassExist() -> Bool {
        guard KeychainStore.store.getPass() != nil else {
            return false
        }
        
        return true
    }
    
    func setNewPassword(password: String) {
        KeychainStore.store.setPass(password: password)
    }
    
    func checkPass(password: String) -> Bool {
        guard let pass = KeychainStore.store.getPass() else {
            return false
        }
        
        return password == pass
    }
    
    func removePassword() {
        KeychainStore.store.removePass()
    }
    
    func pushTabBarController(navigationController: UINavigationController) {
        let fileManagerService = FileManagerService(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let documentsViewController = DocumentsViewController(fileManageService: fileManagerService)
        let documentsNavigationController = UINavigationController(rootViewController: documentsViewController)
        
        let settingsStore = SettingsStore()
        let settingsViewController = SettingsViewController(store: settingsStore)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.delegate = documentsViewController

        let tabBarController = UITabBarController()
        tabBarController.navigationItem.hidesBackButton = true
        
        documentsNavigationController.tabBarItem = UITabBarItem(title: "Документы", image: .init(systemName: "doc.fill"), tag: 0)
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Настройки", image: .init(systemName: "gear"), tag: 1)
        
        let controllers = [documentsNavigationController, settingsNavigationController]
        
        tabBarController.viewControllers = controllers.map { $0 }
        tabBarController.selectedIndex = 0
        
        navigationController.pushViewController(tabBarController, animated: true)

    }
}
