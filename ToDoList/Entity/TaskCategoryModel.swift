//
//  TaskCategoryModel.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

struct TaskResponse: Decodable {
    let todos: [TaskCategoryModel]
}

struct TaskCategoryModel: Decodable {
    let todo: String
}
