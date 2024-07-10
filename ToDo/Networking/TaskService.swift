//
//  TaskService.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 04/07/24.
//

import Foundation

enum TaskServiceError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
	case invalidUser
	case invalidNewTask
	case invalidDateFormat
}

@MainActor
final class TaskService: ObservableObject {
	var userManager: UserManager
	
	init(userManager: UserManager) {
		self.userManager = userManager
	}
		
	var userToken: String {
		guard let user = userManager.user else {
			return "Invalid user token"
		}
		return user.token
	}
	
	func headersRequest(_ url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue( "Bearer \(userToken)", forHTTPHeaderField: "Authorization")
		return request
	}
	
	func requestTasks() async throws -> [TaskUnity] {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			throw TaskServiceError.invalidURL
		}
		var request = headersRequest(url)
		request.httpMethod = "GET"
		
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw TaskServiceError.invalidData
		}
		
		let tasks = try JSONDecoder().decode([TaskUnity].self, from: data)
		return tasks
	}
	
	func addNewTask(description: String, dueDate: String) async throws -> TaskUnity {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			throw TaskServiceError.invalidURL
		}
		
		let newTask = NewTask(description: description, dueDate: try jsonDateFormatter(dueDate))
		
		guard let jsonData = try? JSONEncoder().encode(newTask) else {
			throw TaskServiceError.invalidNewTask
		}
		
		var request = headersRequest(url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw TaskServiceError.invalidData
		}
		
		let task = try JSONDecoder().decode(TaskUnity.self, from: data)
		return task
	}
				
	func deleteTask(with id: String) async throws -> TaskUnity {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks/" + "\(id)") else {
			throw TaskServiceError.invalidURL
		}
		
		var request = headersRequest(url)
		request.httpMethod = "DELETE"
		
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw TaskServiceError.invalidData
		}
		
		let deletedTask = try JSONDecoder().decode(TaskUnity.self, from: data)
		return deletedTask
	}
}

extension TaskService {
	func jsonDateFormatter(_ stringDate: String) throws -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		
		guard let date = dateFormatter.date(from: stringDate) else {
			throw TaskServiceError.invalidDateFormat
		}
		
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime]
		let isoDate = isoFormatter.string(from: date)
		return isoDate
	}
}
