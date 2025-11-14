//
//  ToDoListInteractor.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import Foundation
import CoreData

final class ToDoListInteractor: ToDoListInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: ToDoListPresenterProtocol?
    private let apiService: TodoAPIServiceProtocol
    
    // MARK: - Init
    init(apiService: TodoAPIServiceProtocol = TodoAPIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Fetch Todos
    func fetchTodos() {
        let context = CoreDataManager.shared.mainContext
        
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let createdAtSort = NSSortDescriptor(key: "createdAt", ascending: false)
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [createdAtSort, idSort]
        
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
    
    // MARK: - API Fetch
    private func fetchTodosFromAPI() {
        apiService.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.saveTodosToCoreData(response.todos)
                
            case .failure(let error):
                let message: String
                switch error {
                case .invalidURL:
                    message = "Некорректный URL"
                case .badData:
                    message = "Получены неверные данные"
                case .badResponse:
                    message = "Ошибка ответа сервера"
                case .badDecode:
                    message = "Ошибка декодирования данных"
                case .badRequest:
                    message = "Неверный запрос"
                case .unknown(let desc):
                    message = "Неизвестная ошибка: \(desc)"
                }
                
                DispatchQueue.main.async {
                    self.presenter?.didFailFetchingTodos(message)
                }
            }
        }
    }
    
    // MARK: - Core Data Saving
    private func saveTodosToCoreData(_ todosDTO: [TodoDTO]) {
        let context = CoreDataManager.shared.backgroundContext
        context.perform {
            for dto in todosDTO {
                
                // Проверяем, существует ли уже задача с таким id
                let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", dto.id)
                let existingTodo = try? context.fetch(fetchRequest).first
                
                // Если есть — обновляем, если нет — создаем новую
                let todo = existingTodo ?? ToDoItem(context: context)
                
                todo.id = Int32(dto.id)
                todo.title = dto.todo
                todo.todoDescription = ""
                todo.isCompleted = dto.completed
                todo.userId = Int32(dto.userId)
                todo.createdAt = Date.distantPast
            }
            
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения JSON в Core Data: \(error)")
            }
            
            self.fetchFromMainContext()
        }
    }
    
    // MARK: - Fetch from Main Context
    private func fetchFromMainContext() {
        let mainContext = CoreDataManager.shared.mainContext
        mainContext.perform {
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            let createdAtSort = NSSortDescriptor(key: "createdAt", ascending: false)
            let idSort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [createdAtSort, idSort]
            
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
