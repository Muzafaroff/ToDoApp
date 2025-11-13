//
//  EditToDoProtocols.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import Foundation
import UIKit

protocol EditTodoViewProtocol: AnyObject {
    func displayTodo(_ todo: ToDoItem)
}

protocol EditTodoPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveChanges(title: String, description: String)
}

protocol EditTodoInteractorProtocol: AnyObject {
    func saveTodo(_ todo: ToDoItem)
}
