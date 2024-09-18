//
//  TaskDetailConfigurator.swift
//  ToDoList
//
//  Created by user on 17.09.2024.
//

import Foundation

// MARK: - Protocol
protocol TaskDetailConfiguratorProtocol: AnyObject {
    func configure(with viewController: TaskDetailViewControllerProtocol)
}

final class TaskDetailConfigurator: TaskDetailConfiguratorProtocol {
    
    // MARK: - Protocol Implementation
    func configure(with viewController: TaskDetailViewControllerProtocol) {
        let presenter: TaskDetailPresenterProtocol = TaskDetailPresenter()
        let interactor: TaskDetailInteractorProtocol = TaskDetailInteractor()
        let router: TaskDetailRouterProtocol = TaskDetailRouter()
        
        viewController.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = viewController
    }
}
