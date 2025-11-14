//
//  EditToDoPresenter.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import UIKit
import Foundation

final class EditTodoPresenter: EditTodoPresenterProtocol {
    
    // MARK: - Properties
    weak var view: EditTodoViewProtocol?
    private let interactor: EditTodoInteractorProtocol
    private var todo: ToDoItem?
    
    // MARK: - Init
    init(todo: ToDoItem?, interactor: EditTodoInteractorProtocol) {
        self.todo = todo
        self.interactor = interactor
    }
    
    // MARK: - View Lifecycle
    func viewDidLoad() {
        view?.displayTodo(todo)
    }
    
    // MARK: - SaveСhanges
    func saveChanges(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty || !trimmedDescription.isEmpty else { return }
        interactor.saveOrUpdateTodo(existingTodo: todo, title: trimmedTitle, description: trimmedDescription)
    }
}
