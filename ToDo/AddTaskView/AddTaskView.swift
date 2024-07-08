import SwiftUI

//MARK: ViewModel
@MainActor
class AddTaskViewModel: ObservableObject {
	var taskService: TaskService
	
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
		}
	}
}

//MARK: View
struct AddTaskView: View {
	@ObservedObject var addTaskViewModel: AddTaskViewModel
	@State var description: String
	@State var dueDate: String
		
	init(viewModel: AddTaskViewModel) {
		let description = ""
		let dueDate = ""
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
				addTaskViewModel.addNewTask(description, dueDate)
			} label: {
				Text("Add Task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
		}
	}
}

//#Preview {
//	AddTaskView(viewModel: AddTaskViewModel(userManager: UserManager()))
//}
