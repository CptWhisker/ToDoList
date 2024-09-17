//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

struct TaskModel {
    let id: UUID
    var title: String
    var description: String
    let createdAt: String?
    var isCompleted: Bool
}

extension TaskModel {
    
    init(from entity: TaskCoreData) {
        self.id = entity.taskID ?? UUID()
        self.title = entity.taskTitle ?? "default"
        self.description = entity.taskDescription ?? ""
        self.createdAt = TaskModel.dateFormatter.string(from: entity.creationDate ?? Date())
        self.isCompleted = entity.taskStatus
    }
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
