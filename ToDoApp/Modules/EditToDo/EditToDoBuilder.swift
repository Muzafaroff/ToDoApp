//
//  EditToDoBuilder.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import UIKit

final class EditTodoModuleBuilder {
    static func build(todo: ToDoItem) -> UIViewController {
        let interactor = EditTodoInteractor()
        let presenter = EditTodoPresenter(todo: todo, interactor: interactor)
        let view = EditTodoViewController()
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
