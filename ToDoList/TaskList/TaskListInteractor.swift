//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

enum TaskFilter {
    case all, completed, incompleted
}

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchTasks()
    func fetchTasks(with filter: TaskFilter)
}

final class TaskListInteractor: TaskListInteractorProtocol {
    
    weak var presenter: TaskListPresenterProtocol?
    
    func fetchTasks() {}
    
    func fetchTasks(with filter: TaskFilter) {}
}
