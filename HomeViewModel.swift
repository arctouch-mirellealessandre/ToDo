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
	
	func deleteTask(_ task: TaskUnity) {
		Task {
			do {
				let task = try await taskService.deleteTask(with: task.id)
				let taskIndex = tasks.firstIndex(of: task)
				
				guard let taskIndex = taskIndex else {
					print("Delete Task Method: couldn't remove task from the array")
					return
				}
				
				tasks.remove(at: taskIndex)
			} catch {
				print("Delete Task Method: couldn't delete task")
			}
		}
	}
	
}
