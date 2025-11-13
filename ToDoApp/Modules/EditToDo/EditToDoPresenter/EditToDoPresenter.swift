//
//  EditToDoPresenter.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import UIKit

import Foundation


final class EditTodoPresenter: EditTodoPresenterProtocol {
    
    weak var view: EditTodoViewProtocol?
    private let interactor: EditTodoInteractorProtocol
    
    private var todo: ToDoItem
    
    init(todo: ToDoItem, interactor: EditTodoInteractorProtocol) {
        self.todo = todo
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        view?.displayTodo(todo)
    }
    
    func saveChanges(title: String, description: String) {
        todo.title = title
        todo.todoDescription = description
        todo.createdAt = Date() 
        
        interactor.saveTodo(todo)
    }
}
