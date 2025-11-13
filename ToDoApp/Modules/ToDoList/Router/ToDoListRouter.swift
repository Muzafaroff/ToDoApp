//
//  ToDoListRouter.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//


import UIKit



final class ToDoListRouter: ToDoListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func showDetail(for todo: ToDoItem) {
        let editVC = EditTodoModuleBuilder.build(todo: todo)
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
}
