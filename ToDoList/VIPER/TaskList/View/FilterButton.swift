//
//  FilterButton.swift
//  ToDoList
//
//  Created by user on 18.09.2024.
//

import UIKit

class FilterButton: UIButton {
    
    // MARK: - UI Elements
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    // MARK: - Initialization
    init(title: String, count: Int) {
        super.init(frame: .zero)
        
        configure(title: title, count: count)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure(title: "", count: 0)
    }
    
    // MARK: - UI Configuration
    private func configure(title: String, count: Int) {
        addSubview(filterLabel)
        addSubview(selectionIndicator)
        addSubview(countLabel)
        
        filterLabel.text = title
        countLabel.text = "\(count)"
        
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            selectionIndicator.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -4),
            selectionIndicator.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 4),
            selectionIndicator.topAnchor.constraint(equalTo: countLabel.topAnchor, constant: -2),
            selectionIndicator.bottomAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 2),
            
            countLabel.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: 8),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func updateCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
    
    func setColor(to color: UIColor) {
        filterLabel.textColor = color
        selectionIndicator.backgroundColor = color
    }
}
