import SwiftUI

//MARK: ViewModel
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

//MARK: View
struct UpdateTaskView: View {
	@State var description: String
	@State var dueDate: String
	@ObservedObject var updateTaskViewModel: UpdateTaskViewModel
	
	init(viewModel: UpdateTaskViewModel) {
		self.description = viewModel.task.description
		self.dueDate = viewModel.task.changeDateFormatToUser()
		self.updateTaskViewModel = viewModel
	}
	
    var body: some View {
		VStack {
			Form() {
				Section {
					TextField("Description", text: $description)
				} header: {
					Text("Rename")
				}
				Section {
					TextField("Date", text: $dueDate)
				} header: {
					Text("new date")
				}
			}
			Button {
				updateTaskViewModel.updateTask(newDescription: description, newDueDate: dueDate)
				
			} label: {
				Text("Update task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -480)
		}
    }
}

