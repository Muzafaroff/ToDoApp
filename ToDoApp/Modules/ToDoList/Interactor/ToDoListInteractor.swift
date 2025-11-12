//
//  ToDoListInteractor.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import Foundation
import CoreData

final class ToDoListInteractor: ToDoListInteractorProtocol {

    weak var presenter: ToDoListPresenterProtocol?
    private let apiService: TodoAPIServiceProtocol

    init(apiService: TodoAPIServiceProtocol = TodoAPIService()) {
        self.apiService = apiService
    }

    func fetchTodos() {
        let context = CoreDataManager.shared.mainContext
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()

        do {
            let todos = try context.fetch(request)
            if todos.isEmpty {
                fetchTodosFromAPI()
            } else {
                presenter?.didFetchTodos(todos)
            }
        } catch {
            presenter?.didFailFetchingTodos("Не удалось загрузить задачи")
        }
    }

    private func fetchTodosFromAPI() {
        apiService.fetchTodos { [weak self] result in
            switch result {
            case .success(let response):
                self?.saveTodosToCoreData(response.todos)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailFetchingTodos("Ошибка сети: \(error)")
                }
            }
        }
    }

    private func saveTodosToCoreData(_ todosDTO: [TodoDTO]) {
        let context = CoreDataManager.shared.backgroundContext
        context.perform {
            for dto in todosDTO {
                let todo = ToDoItem(context: context)
                todo.id = Int32(dto.id)
                todo.title = dto.todo
                todo.todoDescription = ""
                todo.isCompleted = dto.completed
                todo.userId = Int32(dto.userId)
                todo.createdAt = Date()
            }

            CoreDataManager.shared.saveContext(context)

            let mainContext = CoreDataManager.shared.mainContext
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            do {
                let todos = try mainContext.fetch(request)
                DispatchQueue.main.async {
                    self.presenter?.didFetchTodos(todos)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailFetchingTodos("Не удалось загрузить задачи")
                }
            }
        }
    }
}
