//
//  TaskListConfigurator.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

protocol TaskListConfiguratorProtocol: AnyObject {
    func configure(with viewController: TaskListViewControllerProtocol)
}

final class TaskListConfigurator: TaskListConfiguratorProtocol {

    func configure(with viewController: TaskListViewControllerProtocol) {
        let presenter: TaskListPresenterProtocol = TaskListPresenter()
        let interactor: TaskListInteractorProtocol = TaskListInteractor()
        let router: TaskListRouterProtocol = TaskListRouter()
        
        viewController.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = viewController
    }
}
