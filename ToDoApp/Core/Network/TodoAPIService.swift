//
//  TodoAPIService.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 10.11.2025.
//

import Foundation

protocol TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping (Result <TodoResponse, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case badData
    case badResponse
    case badDecode
    case badRequest
    case unknown(String)
}

final class TodoAPIService: TodoAPIServiceProtocol {
    
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchTodos(completion: @escaping (Result<TodoResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.badResponse))
            }
            
            switch response.statusCode {
            case 200...299:
                do {
                    let result = try self.decoder.decode(TodoResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.badDecode))
                }
            case 404:
                completion(.failure(.badRequest))
                
            default:
                completion(.failure(.unknown("Ошибка (\(response.statusCode))")))
                
            }
            
            
        }.resume()
        
    }
}


