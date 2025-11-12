//
//  ToDoListProtocols.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import Foundation
import UIKit


protocol ToDoListViewProtocol: AnyObject {
    func showTodos(_ todos: [ToDoItem])
    func showError(_ message: String)
}

protocol ToDoListPresenterProtocol: AnyObject {
    var view: ToDoListViewProtocol? { get set }

    func viewDidLoad()
    func didSelectTodo(_ todo: ToDoItem)
    func didFetchTodos(_ todos: [ToDoItem])
    func didFailFetchingTodos(_ error: String)
    var router: ToDoListRouterProtocol? { get set }

}

protocol ToDoListInteractorProtocol: AnyObject {
    func fetchTodos()
}

protocol ToDoListRouterProtocol: AnyObject {
    func showDetail(for todo: ToDoItem)
}
