import Foundation

enum TaskServiceError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
	case invalidUser
	case invalidNewTask
	case invalidChanges
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
	
	func postLoginRequest(_ username: String, _ password: String) async throws {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/users/login") else {
			throw LoginRequest.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		let basicAuth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
		request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
		
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw LoginRequest.invalidResponse
		}
		
		userManager.user = try JSONDecoder().decode(User.self, from: data)
		userManager.updateUserState()
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
	
	func updateTask(task: TaskUnity, newDescription: String, newDueDate: String) async throws {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks/" + "\(task.id)") else {
			throw TaskServiceError.invalidURL
		}
		
		var request = headersRequest(url)
		request.httpMethod = "PATCH"
		
		let changes: TaskChanges
		let descriptionChanged = task.description != newDescription
		let dueDateChanged = task.dueDate != newDueDate
		let jsonDateFormat = try changeDateFormatToServer(newDueDate)
		
		if descriptionChanged && dueDateChanged {
			changes = TaskChanges(description: newDescription, dueDate: jsonDateFormat)
		} else if descriptionChanged {
			changes = TaskChanges(description: newDescription)
		} else if dueDateChanged {
			changes = TaskChanges(dueDate: jsonDateFormat)
		} else {
			throw TaskServiceError.invalidChanges
		}

		guard let jsonData = try? JSONEncoder().encode(changes) else {
			throw TaskServiceError.invalidChanges
		}
		
		request.httpBody = jsonData
		
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw TaskServiceError.invalidData
		}
		
		_ = try JSONDecoder().decode(TaskUnity.self, from: data)
	}
	
	func addNewTask(description: String, dueDate: String) async throws {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			throw TaskServiceError.invalidURL
		}
		
		let newTask = NewTask(description: description, dueDate: try changeDateFormatToServer(dueDate))
		
		guard let jsonData = try? JSONEncoder().encode(newTask) else {
			throw TaskServiceError.invalidNewTask
		}
		
		var request = headersRequest(url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw TaskServiceError.invalidData
		}
		
		let _ = try JSONDecoder().decode(TaskUnity.self, from: data)
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
	func changeDateFormatToServer(_ stringDate: String) throws -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yy-MM-dd"
		
		guard let date = dateFormatter.date(from: stringDate) else {
			throw TaskServiceError.invalidDateFormat
		}
		
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime]
		let isoDate = isoFormatter.string(from: date)
		return isoDate
	}
}
