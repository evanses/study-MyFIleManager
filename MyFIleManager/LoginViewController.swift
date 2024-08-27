//
//  LoginViewController.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Data
    
    private var model: LoginViewModel
    
    private var isModalPresenting: Bool {
        return presentingViewController != nil
    }
    
    private var inputedPassword: String?
    
    // MARK: Subviews
    
    private lazy var passwordTextField: TextFieldWithPadding = { [unowned self] in
        let textInput = TextFieldWithPadding()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.font = UIFont.systemFont(ofSize: 16)
        textInput.textColor = .black
        textInput.autocapitalizationType = .none
        textInput.placeholder = "Введите пароль"
        textInput.backgroundColor = .lightGray
        textInput.layer.cornerRadius = 10
        textInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        textInput.keyboardType = UIKeyboardType.default
        textInput.returnKeyType = UIReturnKeyType.done
        
        textInput.layer.masksToBounds = true
        return textInput
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(model: LoginViewModel) {
        self.model = model
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupConstraints()
        
        setupView()
        setupActions()
    }
    
    // MARK: - Private
    
    private func setupView() {        
        if !model.isPassExist() || isModalPresenting {
            self.submitButton.setTitle("Создать пароль", for: .normal)
        } else {
            self.submitButton.setTitle("Введите пароль", for: .normal)
        }
    }
    
    private func addSubviews() {
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            passwordTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 130.0),
            passwordTextField.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -100.0),
            
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            submitButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        if !model.isPassExist() || isModalPresenting {
            submitButton.addTarget(self, action: #selector(sumbitPassword(_:)), for: .touchUpInside)
            
        } else {
            submitButton.addTarget(self, action: #selector(checkPassword(_:)), for: .touchUpInside)
            
        }
    }
    
    // MARK: Actions
    
    @objc func checkPassword(_ sender: UIButton) {
        guard let inPass: String = passwordTextField.text else {
            return
        }
        
        if model.checkPass(password: inPass) {
            model.pushTabBarController(navigationController: navigationController!)
            
        } else {
            AlertView.alert.show(in: self, text: "Пароль неверный!")

        }
    }
    
    @objc func sumbitPassword(_ sender: UIButton) {
        guard let inPass: String = passwordTextField.text else {
            return
        }
        
        if let pass = inputedPassword {
            if pass == inPass {
                model.setNewPassword(password: pass)
                
                if isModalPresenting {
                    dismiss(animated: true)
                } else {
                    model.pushTabBarController(navigationController: navigationController!)
                }
                
            } else {
                AlertView.alert.show(in: self, text: "Введеные пароли не совпадают!")
                
                inputedPassword = nil
                passwordTextField.text = ""
                submitButton.setTitle("Создать пароль", for: .normal)

            }
            
        } else {
            
            if inPass.count >= 4 {
                inputedPassword = inPass
                
                passwordTextField.text = ""
                submitButton.setTitle("Повторите пароль", for: .normal)
                
            } else {
                AlertView.alert.show(in: self, text: "Минимальная длина пароля 4 символа!")
            }
            
        }
    }

}
