//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

// MARK: - TaskFilter
enum TaskFilter {
    case all, completed, incompleted
}

// MARK: - Protocol
protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchTasks()
    func fetchTasks(with filter: TaskFilter)
    func updateTask(_ task: TaskModel, with filter: TaskFilter)
}

final class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: TaskListPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    // MARK: - Initializers
    init(networkService: NetworkServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    convenience init() {
        let networkService: NetworkServiceProtocol = NetworkService()
        let coreDataService: CoreDataServiceProtocol = CoreDataService()
        
        self.init(networkService: networkService, coreDataService: coreDataService)
    }
    
    // MARK: - Protocol Implementation
    func fetchTasks() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            if let categories = self.coreDataService.readCategories(), !categories.isEmpty {
                self.coreDataService.deleteTasksNotFromToday()
                
                let tasks = self.coreDataService.readTasks()
                let counts = self.getFilteredTasksCounts()
                
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks, counts: counts)
                }
            } else {
                loadingHUD.showAnimation()
                self.networkService.fetchTasks { [weak self] result in
                    loadingHUD.dismissAnimation()
                    
                    switch result {
                    case .success(let categories):
                        self?.coreDataService.createCategories(categories)
                        let counts = FilteredTasksCount(all: 0, completed: 0, incompleted: 0)
                        DispatchQueue.main.async {
                            self?.presenter?.didFetchTasks([], counts: counts)
                        }
                    case .failure(let error):
                        print("Failed to fetch categories from network:", error)
                    }
                }
            }
        }
    }
    
    func fetchTasks(with filter: TaskFilter) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            var filteredTasks: [TaskCoreData] = []
            
            switch filter {
            case .all:
                filteredTasks = self.coreDataService.readTasks()
            case .completed:
                filteredTasks = self.coreDataService.readCompletedTasks()
            case .incompleted:
                filteredTasks = self.coreDataService.readIncompletedTasks()
            }
            
            let counts = self.getFilteredTasksCounts()
            
            DispatchQueue.main.async {
                self.presenter?.didFetchTasks(filteredTasks, counts: counts)
            }
        }
    }
    
    func updateTask(_ task: TaskModel, with filter: TaskFilter) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            self.coreDataService.updateTask(task)
            self.fetchTasks(with: filter)
        }
    }
    
    func getFilteredTasksCounts() -> FilteredTasksCount {
        let all = coreDataService.readTasks().count
        let completed = coreDataService.readCompletedTasks().count
        let incompleted = coreDataService.readIncompletedTasks().count
        
        return FilteredTasksCount(all: all, completed: completed, incompleted: incompleted)
    }
}
