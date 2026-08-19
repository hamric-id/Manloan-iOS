//
//  CollateralView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

final class CollateralView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🏠 Collateral Information"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "building.2.fill")
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(typeLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            typeLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 72),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with collateral: Collateral) {
        typeLabel.text = collateral.type
        valueLabel.text = collateral.value.asUSDcurrency
        
        let iconName: String
        switch collateral.type.lowercased() {
        case _ where collateral.type.lowercased().contains("real estate"):
            iconName = "building.2.fill"
        case _ where collateral.type.lowercased().contains("vehicle"):
            iconName = "car.fill"
        case _ where collateral.type.lowercased().contains("cash"):
            iconName = "dollarsign.circle.fill"
        default:
            iconName = "doc.fill"
        }
        iconImageView.image = UIImage(systemName: iconName)
    }
}
