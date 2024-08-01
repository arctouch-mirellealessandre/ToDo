import Foundation

enum LoginRequest: Error {
	case invalidURL
	case invalidResponse
}

@MainActor
final class LoginViewModel: ObservableObject {
	private var userManager: UserManager
	private var taskService: TaskService
	
	@Published var isLoading = false
	
	init(userManager: UserManager, taskService: TaskService) {
		self.userManager = userManager
		self.taskService = taskService
	}
		
	func requestLogin(_ username: String, _ password: String) {
		Task {
			do {
				try await taskService.postLoginRequest(username, password)
			} catch {
				print("Login attempt failed.")
			}
		}
		isLoading = false
	}
}
