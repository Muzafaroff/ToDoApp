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

    
    init(interactor: ToDoListInteractorProtocol) {
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didSelectTodo(_ todo: ToDoItem) {
        // 1. Обновляем статус
        todo.isCompleted.toggle()
        CoreDataManager.shared.saveContext()
        
        // 2. Показываем детали
        router?.showDetail(for: todo)
    }
    
    func didFetchTodos(_ todos: [ToDoItem]) {
        view?.showTodos(todos)
    }
    
    func didFailFetchingTodos(_ error: String) {
        view?.showError(error)
    }
}
