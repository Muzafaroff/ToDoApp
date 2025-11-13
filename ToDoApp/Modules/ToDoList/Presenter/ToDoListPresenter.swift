//
//  ToDoListPresenter.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import Foundation

final class ToDoListPresenter: ToDoListPresenterProtocol {
    
    weak var view: ToDoListViewProtocol?
    private let interactor: ToDoListInteractorProtocol
    var router: ToDoListRouterProtocol?

    
    init(interactor: ToDoListInteractorProtocol, router: ToDoListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didSelectTodo(_ todo: ToDoItem, at indexPath: IndexPath) {

        todo.isCompleted.toggle()
        CoreDataManager.shared.saveContext()
        view?.reloadRow(at: indexPath)
    }
    
    func didFetchTodos(_ todos: [ToDoItem]) {
        view?.showTodos(todos)
    }
    
    func didFailFetchingTodos(_ error: String) {
        view?.showError(error)
    }
    
    func didTapEdit(todo: ToDoItem) {
        router?.showDetail(for: todo)
    }
}
