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
        // Пока просто показываем алерт вместо экрана деталей
        let alert = UIAlertController(title: todo.title,
                                      message: "ID: \(todo.id)\nВыполнено: \(todo.isCompleted ? "Да" : "Нет")",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
