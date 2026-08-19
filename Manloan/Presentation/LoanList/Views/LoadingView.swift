//
//  LoadingView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import UIKit

final class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .systemBlue
        return ai
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading loans..."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
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
        backgroundColor = .systemGroupedBackground
        
        addSubview(activityIndicator)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
