//
//  EditToDoInteractor.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import Foundation
import CoreData

final class EditTodoInteractor: EditTodoInteractorProtocol {
    
    // MARK: - Save / Update Todo
    
    func saveOrUpdateTodo(existingTodo: ToDoItem?, title: String, description: String) {
        let context = CoreDataManager.shared.mainContext
        
        
        let todo = existingTodo ?? ToDoItem(context: context)
        
        todo.title = title.isEmpty ? "Без названия" : title
        todo.todoDescription = description
        todo.isCompleted = existingTodo == nil ? false : todo.isCompleted
        todo.createdAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Core Data save error (saveOrUpdateTodo): \(error)")
        }
    }
}
