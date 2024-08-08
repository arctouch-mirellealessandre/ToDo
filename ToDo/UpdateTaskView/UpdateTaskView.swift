import SwiftUI

struct UpdateTaskView: View {
	@State private var description: String
	@State private var dueDate: String
	@ObservedObject private var updateTaskViewModel: UpdateTaskViewModel
	
	private var loadingMessage = "Updating task..."
	
	init(viewModel: UpdateTaskViewModel) {
		self.description = viewModel.task.description
		self.dueDate = viewModel.task.changeDateFormatToUser()
		self.updateTaskViewModel = viewModel
	}
	
    var body: some View {
		ZStack {
			TwoSectionsCustomForm(
				firstTextFieldText: $description,
				firstHeaderText: "Rename",
				secondTextFieldText: $dueDate,
				secondHeaderText: "New date")
			Button {
				updateTaskViewModel.isUpdatingTask = true
				updateTaskViewModel.updateTask(newDescription: description, newDueDate: dueDate)
			} label: {
				Text("Update task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			
			if updateTaskViewModel.isUpdatingTask {
				LoadingView(message: loadingMessage)
			}
		}
    }
}

