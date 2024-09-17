//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import Foundation

protocol TaskDetailInteractorProtocol: AnyObject {
    var presenter: TaskDetailPresenterProtocol? { get set }
    func fetchCategories()
    func createTask(_ newTask: TaskModel)
    func updateTask(with updatedTask: TaskModel)
    func deleteTask(_ task: TaskModel)
}

final class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: TaskDetailPresenterProtocol?
    private let coreDataService: CoreDataServiceProtocol
    
    // MARK: - Initializers
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    convenience init() {
        let coreDataService: CoreDataServiceProtocol = CoreDataService()
        
        self.init(coreDataService: coreDataService)
    }
    
    // MARK: - Public Methods
    func fetchCategories() {
        if let categories = coreDataService.readCategories() {
            presenter?.didFetchTaskCategories(categories)
        }
    }
    
    func createTask(_ newTask: TaskModel) {
        coreDataService.createTask(newTask)
        presenter?.didCreateOrUpdateTask()
    }
    
    func updateTask(with updatedTask: TaskModel) {
        coreDataService.updateTask(updatedTask)
        presenter?.didCreateOrUpdateTask()
    }
    
    func deleteTask(_ task: TaskModel) {
        coreDataService.deleteTask(task)
        presenter?.didCreateOrUpdateTask()
    }
}
