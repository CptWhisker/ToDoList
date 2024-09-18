//
//  MockTaskListInteractor.swift
//  ToDoListTests
//
//  Created by user on 18.09.2024.
//

import Foundation
@testable import ToDoList

final class MockTaskListInteractor: TaskListInteractorProtocol {
    var presenter: TaskListPresenterProtocol?
    var fetchTasksCalled = false
    var fetchTasksWithFilterCalled = false
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func fetchTasks(with filter: TaskFilter) {
        fetchTasksWithFilterCalled = true
    }
    
    func updateTask(_ task: TaskModel, with filter: TaskFilter) {}
}
