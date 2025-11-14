//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Илья Музафаров on 15.11.2025.
//

import XCTest
@testable import ToDoApp
import CoreData

final class ToDoAppTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    // MARK: - ToDoListPresenter Tests
    
    // Проверка того, что при вызове viewDidLoad у presenter вызывается fetchTodos у интерактора
    func testListPresenterFetchTodos() {
        let mockView = MockListView()
        let mockInteractor = MockListInteractor()
        let presenter = ToDoListPresenter(interactor: mockInteractor, router: MockListRouter())
        presenter.view = mockView
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchCalled)
    }
    
    // Проверка того, что presenter корректно передаёт список задач в view
    func testListPresenterDidFetchTodos() {
        let mockView = MockListView()
        let presenter = ToDoListPresenter(interactor: MockListInteractor(), router: MockListRouter())
        presenter.view = mockView
        
        let todo = ToDoItem(context: CoreDataManager.shared.mainContext)
        todo.title = "Test Task"
        presenter.didFetchTodos([todo])
        
        XCTAssertEqual(mockView.todosShown.count, 1)
        XCTAssertEqual(mockView.todosShown.first?.title, "Test Task")
    }

    // Проверка того, что presenter корректно передаёт сообщение об ошибке в view
    func testListPresenterDidFailFetching() {
        let mockView = MockListView()
        let presenter = ToDoListPresenter(interactor: MockListInteractor(), router: MockListRouter())
        presenter.view = mockView
        
        presenter.didFailFetchingTodos("Ошибка")
        
        XCTAssertEqual(mockView.errorMessage, "Ошибка")
    }
    
    // MARK: - EditTodoPresenter Tests
    
    // Проверка того, что presenter передаёт задачу для редактирования в view
    func testEditPresenterDisplaysTodo() {
        let todo = ToDoItem(context: CoreDataManager.shared.mainContext)
        todo.title = "Edit Task"
        let mockView = MockEditView()
        let interactor = EditTodoInteractor()
        let presenter = EditTodoPresenter(todo: todo, interactor: interactor)
        presenter.view = mockView
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(mockView.displayedTodo?.title, "Edit Task")
    }
    
    // MARK: - ToogleTodoCompletion Tests
    
    // Проверка того, что при выборе задачи переключается её isCompleted
    func testToggleTodoCompletion() {
        let mockView = MockListView()
        let mockInteractor = MockListInteractor()
        let presenter = ToDoListPresenter(interactor: mockInteractor, router: MockListRouter())
        presenter.view = mockView

        let todo = ToDoItem(context: CoreDataManager.shared.mainContext)
        todo.title = "Task"
        todo.isCompleted = false

        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didSelectTodo(todo, at: indexPath)

        XCTAssertTrue(todo.isCompleted)
    }
    
    
    
    // MARK: - Mocks
    
    class MockListView: ToDoListViewProtocol {
        var todosShown: [ToDoItem] = []
        var errorMessage: String?
        func showTodos(_ todos: [ToDoItem]) { todosShown = todos }
        func showError(_ message: String) { errorMessage = message }
        func reloadRow(at indexPath: IndexPath) {}
    }
    
    class MockListInteractor: ToDoListInteractorProtocol {
        var fetchCalled = false
        func fetchTodos() { fetchCalled = true }
    }
    
    class MockListRouter: ToDoListRouterProtocol {
        func showDetail(for todo: ToDoItem?) {}
    }
    
    class MockEditView: EditTodoViewProtocol {
        var displayedTodo: ToDoItem?
        func displayTodo(_ todo: ToDoItem?) { displayedTodo = todo }
    }
    
}


