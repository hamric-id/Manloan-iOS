//
//  LoanSummaryView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

final class LoanSummaryView: UIView {
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
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Amount"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let interestView = createDetailView(title: "Interest")
    private let termView = createDetailView(title: "Term")
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let riskBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
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
        containerView.addSubview(amountLabel)
        containerView.addSubview(amountSubtitleLabel)
        containerView.addSubview(detailsStackView)
        containerView.addSubview(purposeLabel)
        containerView.addSubview(riskBadge)
        
        detailsStackView.addArrangedSubview(interestView)
        detailsStackView.addArrangedSubview(termView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            amountLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            amountSubtitleLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            amountSubtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            detailsStackView.topAnchor.constraint(equalTo: amountSubtitleLabel.bottomAnchor, constant: 16),
            detailsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            detailsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            purposeLabel.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 12),
            purposeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            purposeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            riskBadge.topAnchor.constraint(equalTo: purposeLabel.bottomAnchor, constant: 12),
            riskBadge.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            riskBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            riskBadge.heightAnchor.constraint(equalToConstant: 28),
            riskBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private static func createDetailView(title: String) -> UIView {
        let container = UIView()
        
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.tag = 1
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(valueLabel)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    func configure(with loan: Loan) {
        amountLabel.text = loan.amount.asUSDcurrency
        
        configureDetailView(interestView, value: loan.formattedInterestRate)
        configureDetailView(termView, value: "\(loan.term) month")
        
        purposeLabel.text = "📝 " + loan.purpose
        
        riskBadge.text = loan.riskRating.rawValue + " • " + loan.riskRating.displayName
        switch loan.riskRating {
        case .a:
            riskBadge.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            riskBadge.textColor = .systemGreen
        case .b:
            riskBadge.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            riskBadge.textColor = .systemOrange
        case .c:
            riskBadge.backgroundColor = .systemRed.withAlphaComponent(0.2)
            riskBadge.textColor = .systemRed
        }
    }
    
    private func configureDetailView(_ view: UIView, value: String) {
        if let valueLabel = view.viewWithTag(1) as? UILabel {
            valueLabel.text = value
        }
    }
}
