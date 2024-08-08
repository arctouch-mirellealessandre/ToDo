import SwiftUI

struct AddTaskView: View {
	@State private var description: String
	@State private var dueDate: String
	@ObservedObject private var addTaskViewModel: AddTaskViewModel
	
	private var loadingMessage = "Adding task..."
		
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
		ZStack {
			TwoSectionsCustomForm(
				firstTextFieldText: $description,
				firstHeaderText: "Task",
				secondTextFieldText: $dueDate,
				secondHeaderText: "Due Date")
			Button {
				addTaskViewModel.isAddingNewTask = true
				addTaskViewModel.addNewTask(description, dueDate)
			} label: {
				Text("Add Task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			
			if addTaskViewModel.isAddingNewTask {
				LoadingView(message: loadingMessage)
			}
		}
	}
}
