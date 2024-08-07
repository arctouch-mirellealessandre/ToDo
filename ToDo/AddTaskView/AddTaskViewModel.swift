import Foundation

final class AddTaskViewModel: ObservableObject {
	private var taskService: TaskService
	
	@Published var isAddingNewTask = false
	
	init(taskService: TaskService) {
		self.taskService = taskService
	}
	
	func addNewTask(_ description: String, _ dueDate: String) {
		Task {
			do {
				try await taskService.addNewTask(description: description, dueDate: dueDate)
			} catch {
				print("Error: couldn't add new task")
			}
			await MainActor.run {
				isAddingNewTask = false
			}
		}
	}
}
