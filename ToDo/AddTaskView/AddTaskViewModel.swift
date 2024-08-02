import Foundation

@MainActor
class AddTaskViewModel: ObservableObject {
	var taskService: TaskService
	
	@Published var isAddingNewTask: Bool
	
	init(taskService: TaskService) {
		self.taskService = taskService
		self.isAddingNewTask = false
	}
	
	func addNewTask(_ description: String, _ dueDate: String) {
		Task {
			do {
				try await taskService.addNewTask(description: description, dueDate: dueDate)
			} catch {
				print("Error: couldn't add new task")
			}
		}
		isAddingNewTask = false
	}
}
