//
//  EditToDoInteractor.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import Foundation

final class EditTodoInteractor: EditTodoInteractorProtocol {
    func saveTodo(_ todo: ToDoItem) {
        CoreDataManager.shared.saveContext()
    }
}
