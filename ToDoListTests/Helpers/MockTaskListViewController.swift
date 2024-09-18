//
//  MockTaskListViewController.swift
//  ToDoListTests
//
//  Created by user on 18.09.2024.
//

import Foundation
@testable import ToDoList

final class MockTaskListViewController: TaskListViewControllerProtocol {
    var presenter: TaskListPresenterProtocol?
    
    var showTasksCalled = false
    var showTasksParameters: [TaskModel]?
    var setFilterCountsCalled = false
    var updateDateLabelCalled = false

    func showTasks(_ tasks: [TaskModel]) {
        showTasksCalled = true
        showTasksParameters = tasks
    }
    
    func setFilterCounts(_ counts: FilteredTasksCount, currentFilter: TaskFilter) {
        setFilterCountsCalled = true
    }
    
    func updateDateLabel(with date: String) {
        updateDateLabelCalled = true
    }
}
