//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import Foundation

// MARK: - Protocol
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
    
    // MARK: - Protocol Implementation
    func fetchCategories() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            if let categories = self.coreDataService.readCategories() {
                DispatchQueue.main.async {
                    self.presenter?.didFetchTaskCategories(categories)
                }
            }
        }
    }
    
    func createTask(_ newTask: TaskModel) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.coreDataService.createTask(newTask)
            DispatchQueue.main.async {
                self.presenter?.didCreateOrUpdateTask()
            }
        }
    }
    
    func updateTask(with updatedTask: TaskModel) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.coreDataService.updateTask(updatedTask)
            DispatchQueue.main.async {
                self.presenter?.didCreateOrUpdateTask()
            }
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.coreDataService.deleteTask(task)
            DispatchQueue.main.async {
                self.presenter?.didCreateOrUpdateTask()
            }
        }
    }
}
