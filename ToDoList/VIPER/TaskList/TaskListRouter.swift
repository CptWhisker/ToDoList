//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

// MARK: - Protocol
protocol TaskListRouterProtocol: AnyObject {
    var viewController: TaskListViewControllerProtocol? { get set }
    func navigateToTaskDetail(with task: TaskModel?, delegate: TaskDetailDelegate)
}

final class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: TaskListViewControllerProtocol?
        
    // MARK: - Protocol Implementation
    func navigateToTaskDetail(with task: TaskModel?, delegate: TaskDetailDelegate) {
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.configurator.configure(with: taskDetailVC)
                
        taskDetailVC.presenter?.task = task
        taskDetailVC.presenter?.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: taskDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        if let viewController = viewController as? UIViewController {
            viewController.present(navigationController, animated: true, completion: nil)
        }
    }
}
