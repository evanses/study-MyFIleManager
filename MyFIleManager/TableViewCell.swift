//
//  TableViewCell.swift
//  MyFIleManager
//
//  Created by eva on 20.08.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Data
    
    enum CellType {
        case folder
        case file
    }
    
    // MARK: - Subview
    
    private lazy var pathLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        return label
    }()

    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        contentView.addSubview(pathLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate( [
            pathLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            pathLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            pathLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0)
        ])
    }
    
    // MARK: - Public
    
    func setup(title: String, type: CellType) {
        pathLabel.text = title
        
        switch type {
        case .file:
            print("is file")
            
        case .folder:
            print("is folder")
            
            accessoryType = .disclosureIndicator
        }
    }
    
    func setupHeaderCell(title: String) {
        pathLabel.text = title
        
        pathLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    }

}
