//
//  MockTaskListRouter.swift
//  ToDoListTests
//
//  Created by user on 18.09.2024.
//

import Foundation
@testable import ToDoList

class MockTaskListRouter: TaskListRouterProtocol {
    var viewController: TaskListViewControllerProtocol?
    var navigateToTaskDetailCalled = false
    
    func navigateToTaskDetail(with task: TaskModel?, delegate: TaskDetailDelegate) {
        navigateToTaskDetailCalled = true
    }
}
