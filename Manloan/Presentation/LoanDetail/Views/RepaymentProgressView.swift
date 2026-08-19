//
//  RepaymentProgressView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//


import UIKit

final class RepaymentProgressView: UIView {
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
        label.text = "📊 Repayment Progress"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.progressTintColor = .systemBlue
        pv.trackTintColor = .systemGray5
        pv.layer.cornerRadius = 4
        pv.clipsToBounds = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paidLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        containerView.addSubview(progressLabel)
        containerView.addSubview(progressSubtitleLabel)
        containerView.addSubview(progressBar)
        
        labelsStackView.addArrangedSubview(paidLabel)
        labelsStackView.addArrangedSubview(remainingLabel)
        containerView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            progressSubtitleLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 2),
            progressSubtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: progressSubtitleLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            labelsStackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 12),
            labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            labelsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ])
    }
    
    func configure(progress: Double, totalPaid: Double, remaining: Double) {
        let progressValue = Float(min(progress / 100, 1.0))
        
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseOut) {
            self.progressBar.setProgress(progressValue, animated: true)
        }
        
        progressLabel.text = String(format: "%.1f%%", progress)
        progressSubtitleLabel.text = "Completion"
        paidLabel.text = "💰 Paid: \(totalPaid.asUSDcurrency)"
        remainingLabel.text = "📊 Remaining: \(remaining.asUSDcurrency)"
    }
}
