//
//  BorrowerInfoView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

protocol BorrowerInfoViewDelegate: AnyObject {
    func borrowerInfoViewDidTapEmail(email: String)
}

final class BorrowerInfoView: UIView {
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
        label.text = "👤 Borrower Information"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let creditScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailTapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    weak var delegate: BorrowerInfoViewDelegate?
    private var email: String = ""
    
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
        containerView.addSubview(nameLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(creditScoreLabel)
        containerView.addSubview(emailButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: -8),
            
            emailButton.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emailButton.widthAnchor.constraint(equalToConstant: 36),
            emailButton.heightAnchor.constraint(equalToConstant: 36),
            
            creditScoreLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            creditScoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            creditScoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            creditScoreLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        emailButton.addTarget(self, action: #selector(handleEmailTap), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEmailTap))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(tapGesture)
        
        emailButton.accessibilityLabel = "Send email to borrower"
        emailButton.accessibilityHint = "Opens your email app"
    }
    
    func configure(with borrower: Borrower) {
        nameLabel.text = borrower.name
        emailLabel.text = "✉️ " + borrower.email
        creditScoreLabel.text = "📊 Credit Score: \(borrower.creditScore)"
        email = borrower.email
    }
    
    @objc private func handleEmailTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        delegate?.borrowerInfoViewDidTapEmail(email: email)
    }
}
