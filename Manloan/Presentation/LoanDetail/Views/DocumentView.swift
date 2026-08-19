//
//  DocumentView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

final class DocumentView: UIView {
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
        label.text = "📁 Documents"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(DocumentCell.self, forCellReuseIdentifier: DocumentCell.identifier)
        tv.isScrollEnabled = false
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .clear
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tv
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No documents available"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var documents: [Document] = []
    private var parentViewController: UIViewController?
    
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
        containerView.addSubview(emptyStateLabel)
        
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
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(with documents: [Document], parentViewController: UIViewController? = nil) {
        self.documents = documents
        self.parentViewController = parentViewController
        
        if documents.isEmpty {
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
            
            let height = CGFloat(documents.count * 56)
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        }
    }
}

extension DocumentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier, for: indexPath) as? DocumentCell else {
            return UITableViewCell()
        }
        
        let document = documents[indexPath.row]
        cell.configure(with: document)
        return cell
    }
}

extension DocumentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let document = documents[indexPath.row]
        let viewerVC = DocumentViewerViewController(document: document)
        viewerVC.modalPresentationStyle = .fullScreen
        
        parentViewController?.present(viewerVC, animated: true)
    }
}
