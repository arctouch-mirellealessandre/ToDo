import SwiftUI

//MARK: ViewModel
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

//MARK: View
struct AddTaskView: View {
	@State var description: String
	@State var dueDate: String
	@ObservedObject var addTaskViewModel: AddTaskViewModel
		
	init(viewModel: AddTaskViewModel) {
		let description = "Go running"
		let dueDate = "2024-07-25"
		self.addTaskViewModel = viewModel
		self.description = description
		self.dueDate = dueDate
	}
	
	var body: some View {
		VStack(alignment: .center) {
			Text("Add New Task")
				.bold()
				.font(.system(size: 25))
		}
		ZStack() {
			Form {
				Section {
					TextField("Description", text: $description)
				} header: {
					Text("Task")
				}
				Section {
					TextField("Date", text: $dueDate)
				} header: {
					Text("Due Date")
				}
			}
			Button {
				addTaskViewModel.isAddingNewTask = true
				addTaskViewModel.addNewTask(description, dueDate)
			} label: {
				Text("Add Task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			
			if addTaskViewModel.isAddingNewTask {
				LoadingView(message: "Adding task")
			}
		}
	}
}
