//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    var viewController: TaskListViewControllerProtocol? { get set }
    func navigateToTaskDetail(with task: TaskViewModel?, from viewController: UIViewController)
}

final class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: TaskListViewControllerProtocol?
    
    func navigateToTaskDetail(with task: TaskViewModel?, from viewController: UIViewController) {}
}
