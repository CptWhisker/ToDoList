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
    func didFetchTasks(_ tasks: [TaskCoreData])
    func didTapAddTaskButton()
    func didSelectTask(_ task: TaskViewModel)
}

final class TaskListPresenter: TaskListPresenterProtocol {

    weak var viewController: TaskListViewControllerProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    func viewDidLoad() {}
    
    func filterAllTasks() {}
    
    func filterCompletedTasks() {}
    
    func filterIncompletedTasks() {}
    
    func didFetchTasks(_ tasks: [TaskCoreData]) {}
    
    func didTapAddTaskButton() {}
    
    func didSelectTask(_ task: TaskViewModel) {}
}
