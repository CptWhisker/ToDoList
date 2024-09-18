//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import Foundation

// MARK: - DelegateProtocol
protocol TaskDetailDelegate: AnyObject {
    func didCreateOrUpdateTask()
}

// MARK: - Protocol
protocol TaskDetailPresenterProtocol: AnyObject {
    var delegate: TaskDetailDelegate? { get set }
    var viewController: TaskDetailViewControllerProtocol? { get set }
    var interactor: TaskDetailInteractorProtocol? { get set }
    var router: TaskDetailRouterProtocol? { get set }
    var task: TaskModel? { get set }
    func viewDidLoad()
    func didFetchTaskCategories(_ categories: [TaskCategoryCoreData])
    func didCreateOrUpdateTask()
    func didSelectCategory(_ category: String)
    func didTapDoneButton(description: String)
    func didTapDeleteButton()
    func didTapBackButton()
}

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    // MARK: - Properties
    weak var delegate: TaskDetailDelegate?
    weak var viewController: TaskDetailViewControllerProtocol?
    var interactor: TaskDetailInteractorProtocol?
    var router: TaskDetailRouterProtocol?
    var task: TaskModel?
    var selectedCategory: String?
    
    // MARK: - Protocol Implementation
    func viewDidLoad() {
        interactor?.fetchCategories()
        
        if let task {
            selectedCategory = task.title
            viewController?.setSelectedDescription(task.description)
        }
    }
    
    func didFetchTaskCategories(_ categories: [TaskCategoryCoreData]) {
        var stringCategories: [String] = []
                
        categories.forEach { stringCategories.append(TaskCategoryModel(from: $0).todo)}
                
        DispatchQueue.main.async { [weak viewController] in
            viewController?.showCategories(stringCategories)
        }
    }
    
    func didCreateOrUpdateTask() {
        delegate?.didCreateOrUpdateTask()
        router?.navigateToTaskList()
    }
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func didTapDoneButton(description: String) {
        if let selectedCategory {
            if task != nil {
                let updatedTask = TaskModel(
                    id: task?.id ?? UUID(),
                    title: selectedCategory,
                    description: description,
                    createdAt: task?.createdAt ?? "",
                    isCompleted: task?.isCompleted ?? false
                )
                interactor?.updateTask(with: updatedTask)
            } else {
                let newTask = TaskModel(
                    id: UUID(),
                    title: selectedCategory,
                    description: description,
                    createdAt: "",
                    isCompleted: false
                )
                interactor?.createTask(newTask)
            }
        }
    }
    
    func didTapDeleteButton() {
        if let task {
            interactor?.deleteTask(task)
        }
    }
    
    func didTapBackButton() {
        router?.navigateToTaskList()
    }
}
