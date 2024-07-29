import SwiftUI

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

