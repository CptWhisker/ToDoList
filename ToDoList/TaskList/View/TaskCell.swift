//
//  TaskCell.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didTapCompleteButton(for task: TaskModel)
}

final class TaskCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var task: TaskModel?
    weak var delegate: TaskCellDelegate?
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var completionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(infoStackView)
        contentView.addSubview(completionButton)
        contentView.addSubview(separatorLine)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            completionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completionButton.centerYAnchor.constraint(equalTo: infoStackView.centerYAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    func configure(with task: TaskModel, delegate: TaskCellDelegate?) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = task.createdAt
        
        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        completionButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Actions
    @objc private func completeTapped() {
        task?.isCompleted.toggle()
        
        if let task {
            delegate?.didTapCompleteButton(for: task)
        }
    }
}
