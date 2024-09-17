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
    func setSelectedCategory(_ category: String)
    func setSelectedDescription(_ description: String)
}

final class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: TaskDetailPresenterProtocol?
    let configurator: TaskDetailConfiguratorProtocol
    private var categories: [String] = [
    "Make homework", "Water plants", "Buy groceries",
    "Purchase new TV", "Play some VideoGames", "Code a little",
    "Pet a cat", "Hide the body", "Picle some veggies",
    "Make homework", "Water plants", "Buy groceries",
    "Purchase new TV", "Play some VideoGames", "Code a little",
    "Pet a cat", "Hide the body", "Picle some veggies",
    "Make homework", "Water plants", "Buy groceries",
    "Purchase new TV", "Play some VideoGames", "Code a little",
    "Pet a cat", "Hide the body", "Picle some veggies"
    ]
    
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
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
//        presenter?.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .todoBackground

        title = "Choose category"
        navigationItem.leftBarButtonItem = backButton

        view.addSubview(categoriesTableView)
        view.addSubview(descriptionTextField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.heightAnchor.constraint(equalToConstant: view.frame.height / 3 * 2),
            
            descriptionTextField.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: categoriesTableView.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: categoriesTableView.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalTo: doneButton.heightAnchor),
            
            doneButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16),
            doneButton.centerXAnchor.constraint(equalTo: descriptionTextField.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
}

// MARK: UITableViewDataSource
extension TaskDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
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
}

// MARK: - TaskDetailViewControllerProtocol
extension TaskDetailViewController: TaskDetailViewControllerProtocol {
    
    func showCategories(_ categories: [String]) {
        self.categories = categories
        
        categoriesTableView.reloadData()
    }
    
    func setSelectedCategory(_ category: String) {}
    
    func setSelectedDescription(_ description: String) {
        descriptionTextField.text = description
    }
}
