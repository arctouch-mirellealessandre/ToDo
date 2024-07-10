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
	case encodingNewTask
}

@MainActor
final class TaskService: ObservableObject {
	var userManager: UserManager
	
	init(userManager: UserManager) {
		self.userManager = userManager
	}
		
	var userToken: String {
		guard let user = userManager.user else {
			return "Invalid user"
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
	
	func addNewTask(description: String, dueDate: String) async throws {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			throw TaskServiceError.invalidURL
		}
		
		let newTask = NewTask(description: description, dueDate: jsonDateFormatter(dueDate))
		
		guard let jsonData = try? JSONEncoder().encode(newTask) else {
			print("Error: Trying to convert newTask into JSON Data")
			return
		}
		var request = headersRequest(url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		let (data, _) = try! await URLSession.shared.data(for: request)
		let task = try! JSONDecoder().decode(TaskUnity.self, from: data)
	}
				
	func deleteTask(with id: String) async throws -> TaskUnity {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks/" + "\(id)") else {
			throw TaskServiceError.invalidURL
		}
		
		var request = headersRequest(url)
		request.httpMethod = "DELETE"
		let (data, _) = try! await URLSession.shared.data(for: request)
		
		let deletedTask = try! JSONDecoder().decode(TaskUnity.self, from: data)
		return deletedTask
	}
	
	func jsonDateFormatter(_ stringDate: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		let date = dateFormatter.date(from: stringDate)
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime]
		let isoDate = isoFormatter.string(from: date!)
		return isoDate
	}
}
