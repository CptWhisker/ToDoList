//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var viewController: TaskListViewControllerProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }
    func viewDidLoad()
    func filterAllTasks()
    func filterCompletedTasks()
    func filterIncompletedTasks()
    func didFetchTasks(_ tasks: [TaskCoreData], counts: FilteredTasksCount)
    func didTapAddTaskButton()
    func didSelectTask(_ task: TaskModel)
}

final class TaskListPresenter: TaskListPresenterProtocol {

    // MARK: - Properties
    weak var viewController: TaskListViewControllerProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    // MARK: - Public Methods
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func filterAllTasks() {
        interactor?.fetchTasks(with: .all)
    }
    
    func filterCompletedTasks() {
        interactor?.fetchTasks(with: .completed)
    }
    
    func filterIncompletedTasks() {
        interactor?.fetchTasks(with: .incompleted)
    }
    
    func didFetchTasks(_ tasks: [TaskCoreData], counts: FilteredTasksCount) {
        let tasks = tasks.map { TaskModel(from: $0) }
        viewController?.showTasks(tasks)
    }
    
    func didTapAddTaskButton() {
        router?.navigateToTaskDetail(with: nil)
    }
    
    func didSelectTask(_ task: TaskModel) {
        router?.navigateToTaskDetail(with: task)
    }
}
