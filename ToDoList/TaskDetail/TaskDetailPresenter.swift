//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import Foundation

protocol TaskDetailDelegate: AnyObject {
    func didCreateTask()
}

protocol TaskDetailPresenterProtocol: AnyObject {
    var delegate: TaskDetailDelegate? { get set }
    var viewController: TaskDetailViewControllerProtocol? { get set }
    var interactor: TaskDetailInteractorProtocol? { get set }
    var router: TaskDetailRouterProtocol? { get set }
    var task: TaskModel? { get set }
    func viewDidLoad()
    func didFetchTaskCategories(_ categories: [TaskCategoryCoreData])
    func didCreateTask()
    func didSelectCategory(_ category: String)
    func didTapDoneButton(description: String)
    func didTapBackButton()
}

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    // MARK: - Properties
    weak var delegate: TaskDetailDelegate?
    weak var viewController: TaskDetailViewControllerProtocol?
    var interactor: TaskDetailInteractorProtocol?
    var router: TaskDetailRouterProtocol?
    var task: TaskModel?
    var selectedCategory: String? {
        didSet {
            if let selectedCategory {
                viewController?.setSelectedCategory(selectedCategory)
            }
        }
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        interactor?.fetchCategories()
        
        if let task {
            viewController?.setSelectedCategory(task.title)
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
    
    func didCreateTask() {
        delegate?.didCreateTask()
        router?.navigateToTaskList()
    }
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func didTapDoneButton(description: String) {
        if let selectedCategory {
            interactor?.createTask(with: selectedCategory, description: description)
        }
    }
    
    func didTapBackButton() {
        router?.navigateToTaskList()
    }
}
