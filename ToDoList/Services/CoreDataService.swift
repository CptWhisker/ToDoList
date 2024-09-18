//
//  CoreDataService.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit
import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func createCategories(_ categories: [TaskCategoryModel])
    func createTask(_ task: TaskModel)
    func readCategories() -> [TaskCategoryCoreData]?
    func readTasks() -> [TaskCoreData]
    func readCompletedTasks() -> [TaskCoreData]
    func readIncompletedTasks() -> [TaskCoreData]
    func updateTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
    func deleteTasksNotFromToday()
}

final class CoreDataService: CoreDataServiceProtocol {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        self.init(context: context)
    }
    
    // MARK: - CREATE
    func createCategories(_ categories: [TaskCategoryModel]) {
        for category in categories {
            let newCategory = TaskCategoryCoreData(context: context)
            newCategory.taskCategoryID = UUID()
            newCategory.taskCategoryTitle = category.todo
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save categories:", error)
        }
    }
    
    func createTask(_ task: TaskModel) {
        let newTask = TaskCoreData(context: context)
        newTask.taskID = UUID()
        newTask.taskTitle = task.title
        newTask.taskDescription = task.description
        newTask.creationDate = Date()
        newTask.taskStatus = task.isCompleted
        
        do {
            try context.save()
        } catch {
            print("Failed to save task:", error)
        }
    }
    
    // MARK: - READ
    func readCategories() -> [TaskCategoryCoreData]? {
        let fetchRequest = TaskCategoryCoreData.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories:", error)
            return nil
        }
    }
    
    func readTasks() -> [TaskCoreData] {
        let fetchRequest = TaskCoreData.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks:", error)
            return []
        }
    }
    
    func readCompletedTasks() -> [TaskCoreData] {
        let fetchRequest = TaskCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TaskCoreData.taskStatus), NSNumber(value: true)
        )
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks:", error)
            return []
        }
    }
    
    func readIncompletedTasks() -> [TaskCoreData] {
        let fetchRequest = TaskCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TaskCoreData.taskStatus), NSNumber(value: false)
        )
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks:", error)
            return []
        }
    }
    
    //MARK: - UPDATE
    func updateTask(_ task: TaskModel) {
        let fetchRequest = TaskCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TaskCoreData.taskID), task.id as CVarArg
        )
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let taskToUpdate = tasks.first {
                taskToUpdate.taskTitle = task.title
                taskToUpdate.taskDescription = task.description
                taskToUpdate.taskStatus = task.isCompleted
                
                try context.save()
            }
        } catch {
            print("Failed to update task:", error)
        }
    }
    
    // MARK: - DELETE
    func deleteTask(_ task: TaskModel) {
        let fetchRequest = TaskCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TaskCoreData.taskID), task.id as CVarArg
        )
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let taskToDelete = tasks.first {
                context.delete(taskToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete task:", error)
        }
    }
    
    func deleteTasksNotFromToday() {
        let fetchRequest = TaskCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        fetchRequest.predicate = NSPredicate(
            format: "%K < %@",
            #keyPath(TaskCoreData.creationDate), startOfDay as NSDate
        )
        
        do {
            let oldTasks = try context.fetch(fetchRequest)
            for task in oldTasks {
                context.delete(task)
            }
            try context.save()
        } catch {
            print("Failed to delete tasks not from today:", error)
        }
    }
}
