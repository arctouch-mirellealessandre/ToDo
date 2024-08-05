import Foundation

final class UpdateTaskViewModel: ObservableObject {
	var taskService: TaskService
	var task: TaskUnity
	
	@Published var isUpdatingTask = false
	
	init(taskService: TaskService, task: TaskUnity) {
		self.taskService = taskService
		self.task = task
	}
	
	func updateTask(newDescription: String, newDueDate: String) {
		Task {
			do {
				try await taskService.updateTask(task: task, newDescription: newDescription, newDueDate: newDueDate)
			} catch {
				print("UpdateTaskViewModel: something's wrong with updateTask method")
			}
		}
		isUpdatingTask = false
	}
}
