//
//  DocumentCell.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 20/08/26.
//


import UIKit

final class DocumentCell: UITableViewCell {
    static let identifier = "DocumentCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "doc.fill")
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            typeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            typeLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with document: Document) {
        nameLabel.text = document.type
        typeLabel.text = document.url.components(separatedBy: ".").last?.uppercased() ?? "FILE"
        
        let fileExtension = document.url.components(separatedBy: ".").last?.lowercased() ?? ""
        let iconName: String
        switch fileExtension {
        case "pdf": iconName = "doc.fill"
        case "jpeg", "jpg", "png", "gif": iconName = "photo.fill"
        case "doc", "docx": iconName = "doc.text.fill"
        case "xls", "xlsx": iconName = "chart.bar.doc.fill"
        default: iconName = "doc.fill"
        }
        iconImageView.image = UIImage(systemName: iconName)
    }
}
