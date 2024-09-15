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
    
    // MARK: - Public Methods
    func fetchTasks() {
        if let categories = coreDataService.readCategories(), !categories.isEmpty {
            let tasks = coreDataService.readTasks()
            let counts = getFilteredTasksCounts()
            presenter?.didFetchTasks(tasks, counts: counts)
        } else {
            networkService.fetchTasks { [weak self] result in
                switch result {
                case .success(let categories):
                    self?.coreDataService.createCategories(categories)
                    let counts = FilteredTasksCount(all: 0, completed: 0, incompleted: 0)
                    self?.presenter?.didFetchTasks([], counts: counts)
                case .failure(let error):
                    print("Failed to fetch categories from network:", error)
                }
            }
        }
    }
    
    func fetchTasks(with filter: TaskFilter) {
        var filteredTasks: [TaskCoreData] = []
        
        switch filter {
        case .all:
            filteredTasks = coreDataService.readTasks()
        case .completed:
            filteredTasks = coreDataService.readCompletedTasks()
        case .incompleted:
            filteredTasks = coreDataService.readIncompletedTasks()
        }
        
        let counts = getFilteredTasksCounts()
        presenter?.didFetchTasks(filteredTasks, counts: counts)
    }
    
    func getFilteredTasksCounts() -> FilteredTasksCount {
        let all = coreDataService.readTasks().count
        let completed = coreDataService.readCompletedTasks().count
        let incompleted = coreDataService.readIncompletedTasks().count
        
        return FilteredTasksCount(all: all, completed: completed, incompleted: incompleted)
    }
}
