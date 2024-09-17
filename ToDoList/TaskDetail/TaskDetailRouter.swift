//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import UIKit

protocol TaskDetailRouterProtocol: AnyObject {
    var viewController: TaskDetailViewControllerProtocol? { get set }
    func navigateToTaskList()
}

final class TaskDetailRouter: TaskDetailRouterProtocol {
    
    weak var viewController: TaskDetailViewControllerProtocol?
    
    func navigateToTaskList() {
        if let viewController = viewController as? UIViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
