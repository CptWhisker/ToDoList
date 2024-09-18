//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

// MARK: - Protocol
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
    var currentFilter: TaskFilter = .all
    
    // MARK: - Protocol Implementation
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func filterAllTasks() {
        currentFilter = .all
        interactor?.fetchTasks(with: .all)
    }
    
    func filterCompletedTasks() {
        currentFilter = .completed
        interactor?.fetchTasks(with: .completed)
    }
    
    func filterIncompletedTasks() {
        currentFilter = .incompleted
        interactor?.fetchTasks(with: .incompleted)
    }
    
    func didFetchTasks(_ tasks: [TaskCoreData], counts: FilteredTasksCount) {
        let tasks = tasks.map { TaskModel(from: $0) }
        let filter = currentFilter
        
        DispatchQueue.main.async { [weak viewController] in
            viewController?.setFilterCounts(counts, currentFilter: filter)
            viewController?.showTasks(tasks)
        }
    }
    
    func didTapAddTaskButton() {
        router?.navigateToTaskDetail(with: nil, delegate: self)
    }
    
    func didSelectTask(_ task: TaskModel) {
        router?.navigateToTaskDetail(with: task, delegate: self)
    }
}

// MARK: - TaskCellDelegate
extension TaskListPresenter: TaskCellDelegate {
    func didTapCompleteButton(for task: TaskModel) {
        interactor?.updateTask(task, with: currentFilter)
    }
}

// MARK: - TaskDetailDelegate
extension TaskListPresenter: TaskDetailDelegate {
    func didCreateOrUpdateTask() {
        interactor?.fetchTasks(with: currentFilter)
    }
}
