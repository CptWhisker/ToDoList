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
    func createTask(with category: String, description: String)
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
        
    }
    
    func createTask(with category: String, description: String) {
        let task = TaskModel(
            id: UUID(),
            title: category,
            description: description,
            createdAt: nil,
            isCompleted: false
        )
        
        coreDataService.createTask(task)
        
        presenter?.didCreateTask()
    }
}
