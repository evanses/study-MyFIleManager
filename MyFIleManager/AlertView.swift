//
//  AlertView.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation
import UIKit

final class AlertView {
    static let alert = AlertView()
    
    func show(in viewController: UIViewController, text: String) {
        let alert = UIAlertController(
            title: text,
            message: nil,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okButton)
        
        viewController.present(alert, animated: true)
    }
}
