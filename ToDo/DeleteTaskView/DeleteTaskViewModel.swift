import Foundation

@MainActor
final class DeleteTaskViewModel {
	private var taskService: TaskService
	private var homeViewModel: HomeViewModel
	
	@Published var isDeletingTask = false
	
	init(taskService: TaskService, homeViewModel: HomeViewModel) {
		self.taskService = taskService
		self.homeViewModel = homeViewModel
	}
	
	func deleteTask(_ task: TaskUnity) {
		Task {
			do {
				let task = try await taskService.deleteTask(with: task.id)
				let taskIndex = homeViewModel.tasks.firstIndex(of: task)
				guard let taskIndex = taskIndex else {
					print("Delete Task Method: couldn't remove task")
					return
				}
				homeViewModel.tasks.remove(at: taskIndex)
			} catch {
				print("Delete Task Method: couldn't delete task")
			}
			isDeletingTask = false
		}
	}
}
