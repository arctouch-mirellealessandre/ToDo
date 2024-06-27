import SwiftUI

//MARK: ViewModel
class AddTaskViewModel: ObservableObject {
	private var userManager: UserManager

	init(userManager: UserManager) {
		self.userManager = userManager
	}
	
	//its a post method
	func addNewTask(name: String, dueDate: String) async throws -> TaskUnity {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			throw AddTask.invalidURL
		}
		
		guard let user = userManager.user else {
			throw AddTask.invalidUser
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		let (data, response) = try! await URLSession.shared.data(for: request)
		let task = try JSONDecoder().decode(TaskUnity.self, from: data)
		return task
	}
}

enum AddTask: Error {
	case invalidURL
	case invalidResponse
	case invalidData
	case invalidUser
}

//MARK: View
struct AddTaskView: View {
	@ObservedObject var viewModel: AddTaskViewModel
	@State var name: String
	@State var dueDate: String

	init(viewModel: AddTaskViewModel) {
		var name = "Read a book"
		var dueDate = "25/11/2025"
		self.viewModel = viewModel
		self.name = name
		self.dueDate = dueDate
	}
	
	
	var body: some View {
		VStack(alignment: .center) {
			Text("Add Task")
				.bold()
				.font(.system(size: 25))
			Form {
				Section {
					TextField("Description", text: $name)
				} header: {
					Text("Task")
				}
				Section {
					TextField("Date", text: $dueDate)
				} header: {
					Text("Due Date")
				}
			}
			Button("Add Task") {
				//add task to tasks array
			}
			.buttonStyle(.borderedProminent)
			}
		}
}
		

#Preview {
	AddTaskView(viewModel: AddTaskViewModel(userManager: UserManager()))
}
