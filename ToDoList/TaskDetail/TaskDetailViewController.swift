//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import UIKit

protocol TaskDetailViewControllerProtocol: AnyObject {
    var presenter: TaskDetailPresenterProtocol? { get set }
    func showCategories(_ categories: [String])
    func setSelectedDescription(_ description: String)
}

final class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: TaskDetailPresenterProtocol?
    let configurator: TaskDetailConfiguratorProtocol
    private var categories: [String] = []
    
    // MARK: - Initializers
    init(configurator: TaskDetailConfiguratorProtocol) {
        self.configurator = configurator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let configurator: TaskDetailConfiguratorProtocol = TaskDetailConfigurator()
        
        self.init(configurator: configurator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        return button
    }()
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        return tableView
    }()
    private lazy var descriptionTextField: UITextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter description"
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: attributes
        )
        return textField
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemRed.withAlphaComponent(0.1)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, doneButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .todoBackground

        title = "Choose category"
        navigationItem.leftBarButtonItem = backButton

        view.addSubview(categoriesTableView)
        view.addSubview(descriptionTextField)
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.heightAnchor.constraint(equalToConstant: view.frame.height / 3 * 2),
            
            descriptionTextField.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: categoriesTableView.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: categoriesTableView.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalTo: doneButton.heightAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: descriptionTextField.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        presenter?.didTapBackButton()
    }
    
    @objc private func doneButtonTapped() {
        if let text = descriptionTextField.text {
            presenter?.didTapDoneButton(description: text)
        }
    }
    
    @objc private func deleteButtonTapped() {
        presenter?.didTapDeleteButton()
    }
}

// MARK: UITableViewDataSource
extension TaskDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension TaskDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setLeftAndRightSeparatorInsets(to: 16)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCategory(categories[indexPath.row])
    }
}

// MARK: - TaskDetailViewControllerProtocol
extension TaskDetailViewController: TaskDetailViewControllerProtocol {
    
    func showCategories(_ categories: [String]) {
        self.categories = categories
        
        categoriesTableView.reloadData()
    }
    
    func setSelectedDescription(_ description: String) {
        descriptionTextField.text = description
    }
}
