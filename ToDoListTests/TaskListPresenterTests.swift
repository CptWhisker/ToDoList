//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by user on 15.09.2024.
//

import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {

    var presenter: TaskListPresenter!
    var mockViewController: MockTaskListViewController!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!
    
    override func setUpWithError() throws {
        super.setUp()
        mockViewController = MockTaskListViewController()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        
        presenter = TaskListPresenter()
        presenter.viewController = mockViewController
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDownWithError() throws {
        presenter = nil
        mockViewController = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoadFetchingTasks() {
        // WHEN
        presenter.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInteractor.fetchTasksCalled)
        XCTAssertTrue(mockViewController.updateDateLabelCalled)
    }

    func testDidFetchTasksUpdatingView() {
        // GIVEN
        let tasks: [TaskCoreData] = []
        let counts = FilteredTasksCount(all: 1, completed: 0, incompleted: 1)
        
        // WHEN
        presenter.didFetchTasks(tasks, counts: counts)
        
        // THEN
        XCTAssertTrue(mockViewController.setFilterCountsCalled)
        XCTAssertTrue(mockViewController.showTasksCalled)
        XCTAssertEqual(mockViewController.showTasksParameters?.count, 0)
    }
    
    func testDidTapAddTaskButtonRouterNavigation() {
        // WHEN
        presenter.didTapAddTaskButton()
        
        // THEN
        XCTAssertTrue(mockRouter.navigateToTaskDetailCalled)
    }
    
    func testDidSelectTaskRouterNavigation() {
        // GIVEN
        let mockTask = TaskModel(
            id: UUID(),
            title: "TestTitle",
            description: "TestDescription",
            createdAt: "TestDate",
            isCompleted: false
        )
        
        // WHEN
        presenter.didSelectTask(mockTask)
        
        // THEN
        XCTAssertTrue(mockRouter.navigateToTaskDetailCalled)
    }

}
