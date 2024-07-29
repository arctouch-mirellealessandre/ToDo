import Foundation

class UpdateTaskViewModel: ObservableObject {
	var taskService: TaskService
	var task: TaskUnity
	
	init(taskService: TaskService, task: TaskUnity) {
		self.taskService = taskService
		self.task = task
	}
	
	func updateTask(newDescription: String, newDueDate: String) {
		print("New description: \(newDescription)")
		print("Task description: \(task.description)")
		
		Task {
			do {
				try await taskService.updateTask(task: task, newDescription: newDescription, newDueDate: newDueDate)
			} catch {
				print("UpdateTaskViewModel: something's wrong with updateTask method")
			}
		}
		
	}
}
