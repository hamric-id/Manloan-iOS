//
//  PaymentScheduleView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import UIKit

final class PaymentScheduleView: UIView {
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
        label.text = "📅 Payment Schedule"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    
    
    private var installments: [Installment] = []
    
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
        containerView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
    func configure(with installments: [Installment]) {
        self.installments = installments
        tableView.reloadData()
        
        let height = CGFloat(installments.count * 44)
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
    }
}

extension PaymentScheduleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as? PaymentCell else {
            return UITableViewCell()
        }
        
        let installment = installments[indexPath.row]
        cell.configure(with: installment)
        return cell
    }
}

extension PaymentScheduleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

final class PaymentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupUI() {
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            dueDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dueDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dueDateLabel.widthAnchor.constraint(equalToConstant: 110),
            
            amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(with installment: Installment) {
        dueDateLabel.text = installment.formattedDueDate
        amountLabel.text = installment.amountDue.asUSDcurrency
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let dueDate = formatter.date(from: installment.dueDate) else { return }
        
        if dueDate < Date() {
            statusLabel.text = "✅ Paid"
            statusLabel.textColor = .systemGreen
            backgroundColor = .systemGreen.withAlphaComponent(0.05)
        } else if Calendar.current.isDateInToday(dueDate) {
            statusLabel.text = "🔴 Due Today"
            statusLabel.textColor = .systemOrange
            backgroundColor = .systemOrange.withAlphaComponent(0.05)
        } else {
            statusLabel.text = "⏳ Upcoming"
            statusLabel.textColor = .secondaryLabel
            backgroundColor = .clear
        }
    }
}
