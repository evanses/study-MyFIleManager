//
//  RootViewController.swift
//  MyFIleManager
//
//  Created by eva on 20.08.2024.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: - Data
    
    var fileManageService: FileManagerServiceProtocol
    
    private enum TableViewCellReuseID: String {
        case header = "HeaderTableViewCellReuseID_ReuseID"
        case main = "MainTableViewCellReuseID_ReuseID"
    }
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    // MARK: - Lifecycle
    
    init(fileManageService: FileManagerServiceProtocol) {
        self.fileManageService = fileManageService
        
        print(self.fileManageService.contentsOfDirectory())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationBarSetup()
        
        addSubviews()
        setupConstraints()
        
        tuneTableView()

    }

    // MARK: - Private
    
    private func tuneTableView() {
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: TableViewCellReuseID.main.rawValue
        )
        
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: TableViewCellReuseID.header.rawValue
        )
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor)
        ])
    }
    
    private func navigationBarSetup() {
        let addFolderButton = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addFolder)
        )
        
        let addItemButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addItem)
        )
        
        navigationItem.rightBarButtonItems = [addItemButton, addFolderButton]
    }
    
    // MARK: - Actions
    
    @objc private func addFolder() {
        CreateFolderPicker.picker.inputFolderNameView(in: self) { [weak self] text in
            guard let self else {
                return
            }
            
            fileManageService.createDirectory(title: text)
            
            tableView.reloadData()
        }
    }
    
    @objc private func addItem() {
        print("addItem")

        present(imagePicker, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension RootViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellReuseID.main.rawValue,
                for: indexPath
            ) as? TableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            cell.setupHeaderCell(title: fileManageService.getFolderName())
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellReuseID.main.rawValue,
            for: indexPath
        ) as? TableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let item = fileManageService.contentsOfDirectory()[indexPath.row]
        
        if fileManageService.isFolder(index: indexPath.row) {
            cell.setup(title: item, type: .folder)
        } else {
            cell.setup(title: item, type: .file)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return fileManageService.contentsOfDirectory().count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManageService.removeContent(index: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
        
}

// MARK: - UITableViewDelegate

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let item = fileManageService.contentsOfDirectory()[indexPath.row]
            
            if fileManageService.isFolder(index: indexPath.row) {
                let nextFileManager = FileManagerService(path: fileManageService.path + "/" + item)
                let nextViewController = RootViewController(fileManageService: nextFileManager)
                
                navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RootViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }
        
        fileManageService.createFile(
            img: image,
            fileName: url.lastPathComponent
        )
        
        tableView.reloadData()

    }
}
