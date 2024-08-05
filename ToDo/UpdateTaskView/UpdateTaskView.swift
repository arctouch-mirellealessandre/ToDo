import SwiftUI

struct UpdateTaskView: View {
	@State var description: String
	@State var dueDate: String
	@ObservedObject var updateTaskViewModel: UpdateTaskViewModel
	
	private var loadingMessage = "Updating task..."
	
	init(viewModel: UpdateTaskViewModel) {
		self.description = viewModel.task.description
		self.dueDate = viewModel.task.changeDateFormatToUser()
		self.updateTaskViewModel = viewModel
	}
	
    var body: some View {
		ZStack {
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

