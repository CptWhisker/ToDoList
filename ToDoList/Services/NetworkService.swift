//
//  NetworkService.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchTasks(completion: @escaping (Result<[TaskCategoryModel], Error>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case noData
}

final class NetworkService: NetworkServiceProtocol {
    
    let decoder = JSONDecoder()
    
    func fetchTasks(completion: @escaping (Result<[TaskCategoryModel], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let tasksResponse = try self.decoder.decode(TaskResponse.self, from: data)
                completion(.success(tasksResponse.todos))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
