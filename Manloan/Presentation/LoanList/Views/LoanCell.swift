//
//  LoanCell.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import UIKit
import SwiftUI

final class LoanCell: UITableViewCell {
    static let identifier = "LoanCell"
    
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let riskBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(detailsLabel)
        containerView.addSubview(purposeLabel)
        containerView.addSubview(riskBadge)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: riskBadge.leadingAnchor, constant: -8),
            
            amountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            riskBadge.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            riskBadge.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -8),
            riskBadge.widthAnchor.constraint(equalToConstant: 36),
            riskBadge.heightAnchor.constraint(equalToConstant: 24),
            
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            detailsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            purposeLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 2),
            purposeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            purposeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
    }
    
    func configure(with loan: Loan) {
        nameLabel.text = loan.borrower.name
        amountLabel.text = loan.amount.asUSDcurrency
        detailsLabel.text = "\(loan.formattedInterestRate) Interest • \(loan.term) months"
        purposeLabel.text = loan.purpose
        
        riskBadge.text = loan.riskRating.rawValue
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
}


#if DEBUG
struct LoanCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoanCellPreview(loan: makeLoan(
                name: "John Doe",
                amount: 50000,
                risk: .a,
                purpose: "Home Renovation"
            ))
            .previewDisplayName("🟢 Low Risk (A)")
            
            LoanCellPreview(loan: makeLoan(
                name: "Jane Smith",
                amount: 75000,
                risk: .b,
                purpose: "Business Expansion"
            ))
            .previewDisplayName("🟡 Medium Risk (B)")
            
            LoanCellPreview(loan: makeLoan(
                name: "Bob Johnson",
                amount: 25000,
                risk: .c,
                purpose: "Education"
            ))
            .previewDisplayName("🔴 High Risk (C)")
            
            LoanCellPreview(loan: makeLoan(
                name: "Alice Williams",
                amount: 100000,
                risk: .a,
                purpose: "Commercial Real Estate",
                term: 120
            ))
            .previewDisplayName("📅 Long Term (120 months)")
            
            LoanCellPreview(loan: makeLoan(
                name: "Charlie Brown",
                amount: 5000,
                risk: .b,
                purpose: "Personal Loan"
            ))
            .previewDisplayName("💰 Small Amount")
        }
        .previewLayout(.fixed(width: 400, height: 130))
        .padding(.horizontal, 16)
    }
    
    static func makeLoan(
        name: String,
        amount: Double,
        risk: RiskRating,
        purpose: String,
        term: Int = 36
    ) -> Loan {
        return Loan(
            id: UUID().uuidString,
            amount: amount,
            interestRate: 0.055,
            term: term,
            purpose: purpose,
            riskRating: risk,
            borrower: Borrower(
                id: UUID().uuidString,
                name: name,
                email: "\(name.lowercased().replacingOccurrences(of: " ", with: "."))@example.com",
                creditScore: Int.random(in: 600...800)
            ),
            collateral: Collateral(
                type: "Real Estate",
                value: amount * 4
            ),
            documents: [],
            repaymentSchedule: RepaymentSchedule(installments: [])
        )
    }
}

struct LoanCellPreview: UIViewRepresentable {
    let loan: Loan
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGroupedBackground
        
        let cell = LoanCell(style: .default, reuseIdentifier: nil)
        cell.configure(with: loan)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(cell)
        NSLayoutConstraint.activate([
            cell.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            cell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cell.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
#endif
