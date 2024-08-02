import Foundation

class UpdateTaskViewModel: ObservableObject {
	var taskService: TaskService
	var task: TaskUnity
	
	@Published var isUpdatingTask: Bool
	
	init(taskService: TaskService, task: TaskUnity) {
		self.taskService = taskService
		self.task = task
		self.isUpdatingTask = false
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
