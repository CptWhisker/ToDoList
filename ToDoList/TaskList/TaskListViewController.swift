//
//  ViewController.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func showTasks(_ tasks: [TaskViewModel])
    func updateTask(_ task: TaskViewModel)
}

class TaskListViewController: UIViewController, TaskListViewControllerProtocol {
    
    var presenter: TaskListPresenterProtocol?
    let configurator: TaskListConfiguratorProtocol = TaskListConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter?.viewDidLoad()
    }

    func showTasks(_ tasks: [TaskViewModel]) {}
    
    func updateTask(_ task: TaskViewModel) {}
    
}

