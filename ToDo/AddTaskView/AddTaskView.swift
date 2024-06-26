import SwiftUI

//MARK: ViewModel
class AddTaskViewModel {
	
}

//MARK: View
struct AddTaskView: View {
	@State var description: String = ""
	@State var dueDate: String = ""
	
	var body: some View {
		VStack(alignment: .center) {
			Text("Add Task")
				.bold()
				.font(.system(size: 25))
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
				Section {
					Button("Add Task") {
							//add task to tasks array
						}
					.frame(maxWidth: .infinity, alignment: .center)
				}
			}
		}
	}
}

#Preview {
	AddTaskView()
}
