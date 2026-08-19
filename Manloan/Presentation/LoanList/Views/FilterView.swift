//
//  FilterView.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterViewDidSelectFilter(_ filter: FilterOption)
    func filterViewDidSelectSort(_ sort: SortOption)
}

final class FilterView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let filterScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let filterStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let sortScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let sortStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let filterRowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sortRowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var filterButtons: [UIButton] = []
    private var sortButtons: [UIButton] = []
    
    weak var delegate: FilterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .systemGray5
        addSubview(border)
        
        addSubview(containerView)
        
        containerView.addSubview(filterRowView)
        filterRowView.addSubview(filterLabel)
        filterRowView.addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
        
        containerView.addSubview(sortRowView)
        sortRowView.addSubview(sortLabel)
        sortRowView.addSubview(sortScrollView)
        sortScrollView.addSubview(sortStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.5),
            
            filterRowView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            filterRowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filterRowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            filterRowView.heightAnchor.constraint(equalToConstant: 40),
            
            filterLabel.centerYAnchor.constraint(equalTo: filterRowView.centerYAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: filterRowView.leadingAnchor, constant: 16),
            filterLabel.widthAnchor.constraint(equalToConstant: 50),
            
            filterScrollView.centerYAnchor.constraint(equalTo: filterRowView.centerYAnchor),
            filterScrollView.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: 8),
            filterScrollView.trailingAnchor.constraint(equalTo: filterRowView.trailingAnchor, constant: -16),
            filterScrollView.heightAnchor.constraint(equalToConstant: 34),
            
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor),
            
            sortRowView.topAnchor.constraint(equalTo: filterRowView.bottomAnchor, constant: 2),
            sortRowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sortRowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sortRowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            sortRowView.heightAnchor.constraint(equalToConstant: 40),
            
            sortLabel.centerYAnchor.constraint(equalTo: sortRowView.centerYAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: sortRowView.leadingAnchor, constant: 16),
            sortLabel.widthAnchor.constraint(equalToConstant: 50),
            
            sortScrollView.centerYAnchor.constraint(equalTo: sortRowView.centerYAnchor),
            sortScrollView.leadingAnchor.constraint(equalTo: sortLabel.trailingAnchor, constant: 8),
            sortScrollView.trailingAnchor.constraint(equalTo: sortRowView.trailingAnchor, constant: -16),
            sortScrollView.heightAnchor.constraint(equalToConstant: 34),
            
            sortStackView.topAnchor.constraint(equalTo: sortScrollView.topAnchor),
            sortStackView.leadingAnchor.constraint(equalTo: sortScrollView.leadingAnchor),
            sortStackView.trailingAnchor.constraint(equalTo: sortScrollView.trailingAnchor),
            sortStackView.bottomAnchor.constraint(equalTo: sortScrollView.bottomAnchor),
            sortStackView.heightAnchor.constraint(equalTo: sortScrollView.heightAnchor),
        ])
        
        setupFilterButtons()
        setupSortButtons()
    }
    
    private func setupFilterButtons() {
        for filter in FilterOption.allCases {
            let button = createButton(title: filter.rawValue, tag: filter.hashValue)
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
            filterButtons.append(button)
        }
    }
    
    private func setupSortButtons() {
        for sort in SortOption.allCases {
            let button = createButton(title: sort.rawValue, tag: sort.hashValue)
            button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
            sortStackView.addArrangedSubview(button)
            sortButtons.append(button)
        }
    }

    private func createButton(title: String, tag: Int) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .systemBlue.withAlphaComponent(0.1)
        configuration.baseForegroundColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        configuration.cornerStyle = .medium
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.tag = tag
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        filterButtons.forEach { $0.backgroundColor = .systemBlue.withAlphaComponent(0.1) }
        sender.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        
        guard let filter = FilterOption.allCases.first(where: { $0.hashValue == sender.tag }) else { return }
        delegate?.filterViewDidSelectFilter(filter)
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        sortButtons.forEach { $0.backgroundColor = .systemBlue.withAlphaComponent(0.1) }
        sender.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        
        guard let sort = SortOption.allCases.first(where: { $0.hashValue == sender.tag }) else { return }
        delegate?.filterViewDidSelectSort(sort)
    }
    
    func updateFilterSelection(_ filter: FilterOption) {
        filterButtons.forEach { button in
            let isSelected = FilterOption.allCases.first(where: { $0.hashValue == button.tag }) == filter
            button.backgroundColor = isSelected ? .systemBlue.withAlphaComponent(0.3) : .systemBlue.withAlphaComponent(0.1)
        }
    }
    
    func updateSortSelection(_ sort: SortOption) {
        sortButtons.forEach { button in
            let isSelected = SortOption.allCases.first(where: { $0.hashValue == button.tag }) == sort
            button.backgroundColor = isSelected ? .systemBlue.withAlphaComponent(0.3) : .systemBlue.withAlphaComponent(0.1)
        }
    }
}
