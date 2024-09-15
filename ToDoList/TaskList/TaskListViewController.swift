//
//  ViewController.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func showTasks(_ tasks: [TaskModel])
    func updateTask(_ task: TaskModel)
}

class TaskListViewController: UIViewController, TaskListViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: TaskListPresenterProtocol?
    let configurator: TaskListConfiguratorProtocol = TaskListConfigurator()
    private var tasks: [TaskModel] = []
    
    // MARK: - UI Elements
    private var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter?.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        tasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        view.addSubview(tasksTableView)
        
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tasksTableView.reloadData()
    }
    
    func updateTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            let indexPath = IndexPath(row: index, section: 0)
            tasksTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        
        presenter?.didSelectTask(selectedTask)
    }
}

