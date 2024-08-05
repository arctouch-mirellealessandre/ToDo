import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
	@Published var tasks = [TaskUnity]()
	
	var taskService: TaskService
		
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
		}
	}
}
