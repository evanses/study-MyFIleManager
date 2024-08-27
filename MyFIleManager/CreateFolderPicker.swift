//
//  CreateFolderPicker.swift
//  MyFIleManager
//
//  Created by eva on 21.08.2024.
//

import Foundation
import UIKit

final class CreateFolderPicker {
    static let picker = CreateFolderPicker()
    
    func inputFolderNameView(in viewController: UIViewController, completion: @escaping ((_ text: String) -> Void)) {
        let alert = UIAlertController(
            title: "Введи имя папки",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Новая папка"
        }
        
        let addButton = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let text = alert.textFields?[0].text {
                completion(text)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        viewController.present(alert, animated: true)
    }
}
