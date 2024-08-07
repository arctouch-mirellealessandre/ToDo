import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
	var taskService: TaskService
	
	@Published var tasks = [TaskUnity]()
	@Published var isRequestingTasks = false
			
	init(taskService: TaskService) {
		self.taskService = taskService
	}
	
	func requestTasks() {
		Task {
			do {
				tasks = try await taskService.requestTasks()
			} catch {
				print("Couldn't request tasks")
			}
			isRequestingTasks = false
		}
	}
}
