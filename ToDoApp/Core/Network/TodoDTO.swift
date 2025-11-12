//
//  TodoDTO.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 10.11.2025.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int

}
