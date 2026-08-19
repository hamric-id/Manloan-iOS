//
//  LoanDetailViewController.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

final class LoanDetailViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .systemGroupedBackground
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var summaryView: LoanSummaryView = {
        let view = LoanSummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var borrowerInfoView: BorrowerInfoView = {
        let view = BorrowerInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var collateralView: CollateralView = {
        let view = CollateralView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: RepaymentProgressView = {
        let view = RepaymentProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentScheduleView: PaymentScheduleView = {
        let view = PaymentScheduleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var documentView: DocumentView = {
        let view = DocumentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shareButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(handleShare)
        )
    }()
    
    private let loan: Loan
    
    init(loan: Loan) {
        self.loan = loan
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI(with: loan)
    }
    
    private func setupUI() {
        title = "Loan Details"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = shareButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(summaryView)
        contentView.addSubview(borrowerInfoView)
        contentView.addSubview(collateralView)
        contentView.addSubview(progressView)
        contentView.addSubview(paymentScheduleView)
        contentView.addSubview(documentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            summaryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            borrowerInfoView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 16),
            borrowerInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            borrowerInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collateralView.topAnchor.constraint(equalTo: borrowerInfoView.bottomAnchor, constant: 16),
            collateralView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collateralView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: collateralView.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            paymentScheduleView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            paymentScheduleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            paymentScheduleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            documentView.topAnchor.constraint(equalTo: paymentScheduleView.bottomAnchor, constant: 16),
            documentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            documentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            documentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateUI(with loan: Loan) {
        summaryView.configure(with: loan)
        borrowerInfoView.configure(with: loan.borrower)
        
        if let collateral = loan.collateral {
            collateralView.isHidden = false
            collateralView.configure(with: collateral)
        } else {
            collateralView.isHidden = true
            collateralView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        let paidInstallments = loan.repaymentSchedule.installments.filter { installment in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let dueDate = formatter.date(from: installment.dueDate) else { return false }
            return dueDate < Date()
        }.count
        
        let totalPaid = loan.repaymentSchedule.installments.prefix(paidInstallments).reduce(0) { $0 + $1.amountDue }
        
        let totalInstallments = loan.amount
        let progress = totalInstallments > 0 ? (totalPaid / Double(totalInstallments)) * 100 : 0
        
        
        let remaining = totalInstallments - totalPaid
        
        progressView.configure(progress: progress, totalPaid: totalPaid, remaining: remaining)
        paymentScheduleView.configure(with: loan.repaymentSchedule.installments)
        documentView.configure(with: loan.documents)
    }
    
    @objc private func handleShare() {
        guard let shareText = createShareText() else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            popover.barButtonItem = shareButton
        }
        
        present(activityVC, animated: true)
    }
    
    func createShareText() -> String? {
        var lines: [String] = [
            "📋 Loan Summary",
            "──────────────",
            "Borrower: \(loan.borrower.name)",
            "Email: \(loan.borrower.email)",
            "Credit Score: \(loan.borrower.creditScore)",
            "",
            "💰 Amount: \(loan.amount.asUSDcurrency)",
            "📊 Interest Rate: \(loan.formattedInterestRate)",
            "📅 Term: \(loan.term) months",
            "📝 Purpose: \(loan.purpose)",
            "⚠️ Risk Rating: \(loan.riskRating.rawValue)"
        ]
        
        if let collateral = loan.collateral {
            lines.append(contentsOf: [
                "",
                "🏠 Collateral",
                "──────────────",
                "Type: \(collateral.type)",
                "Value: \(collateral.value.asUSDcurrency)"
            ])
        }
        
        return lines.joined(separator: "\n")
    }
}

extension LoanDetailViewController: BorrowerInfoViewDelegate {
    func borrowerInfoViewDidTapEmail(email: String) {
        let subject = "Regarding Your Loan - \(loan.borrower.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = """
        Hello \(loan.borrower.name),
        
        I'm contacting you regarding your loan:
        
        📋 Loan Details:
        • Loan ID: \(loan.id)
        • Amount: \(loan.amount.asUSDcurrency)
        • Interest Rate: \(loan.formattedInterestRate)
        • Term: \(loan.term) months
        • Purpose: \(loan.purpose)
        
        Best regards,
        """
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let emailURL = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        guard let url = URL(string: emailURL) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
