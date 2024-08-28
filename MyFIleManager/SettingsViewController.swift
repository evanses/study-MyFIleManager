//
//  SettingsViewController.swift
//  MyFIleManager
//
//  Created by eva on 27.08.2024.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Data
    
    var delegate: DocumentsViewControllerDelegate?
    private let store: SettingsStore
    
    // MARK: Subviews
    
    private lazy var sortTextLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Сортировка: "
        
        return label
    }()
    
    private lazy var sortModeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        
        label.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(toogleSortMode)
        )
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)

        
        return label
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.setTitle("Сменить пароль", for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    
    init(store: SettingsStore) {
        self.store = store
        
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
    
    // MARK: Private
    
    private func setupView() {
        if store.getSortMode() == 0 {
            sortModeLabel.text = "а-я"
        } else {
            sortModeLabel.text = "я-а"
        }
    }
    
    private func addSubviews() {
        view.addSubview(sortTextLabel)
        view.addSubview(sortModeLabel)
        view.addSubview(changePasswordButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            sortTextLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            sortTextLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
            
            sortModeLabel.topAnchor.constraint(equalTo: sortTextLabel.topAnchor),
            sortModeLabel.leadingAnchor.constraint(equalTo: sortTextLabel.trailingAnchor, constant: 4.0),
            
            changePasswordButton.topAnchor.constraint(equalTo: sortModeLabel.bottomAnchor, constant: 16.0),
            changePasswordButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            changePasswordButton.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -130)
        ])
    }
    
    private func setupActions() {
        changePasswordButton.addTarget(self, action: #selector(changePassword(_:)), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func changePassword(_ sender: UIButton) {
//        KeychainStore.store.removePass()
        
        let model = LoginViewModel()
        let loginViewController = LoginViewController(model: model)
        loginViewController.modalPresentationStyle = .formSheet
        present(loginViewController, animated: true)
    }
    
    @objc private func toogleSortMode() {
        if store.getSortMode() == 0 {
            sortModeLabel.text = "я-а"
            store.setSortMode(sortMode: 1)
            
            AlertView.alert.show(in: self, text: "Сортировна теперь по убыванию")
        } else {
            sortModeLabel.text = "а-я"
            store.setSortMode(sortMode: 0)

            AlertView.alert.show(in: self, text: "Сортировна теперь по возрастанию")

        }
        
        delegate?.reloadTableView()
    }
}
