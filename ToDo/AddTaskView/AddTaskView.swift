import SwiftUI

struct NewTask: Codable {
	let description: String
	let dueDate: String
	
	init(description: String, dueDate: String) {
		self.description = description
		self.dueDate = dueDate
	}
}

//MARK: ViewModel
class AddTaskViewModel: ObservableObject {
	private var userManager: UserManager
	private var tasks: [TaskUnity]
	
	init(userManager: UserManager, tasks: [TaskUnity]) {
		self.userManager = userManager
		self.tasks = tasks
	}
	
	func addNewTask(description: String, dueDate: String) async throws {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks") else {
			print("Error: Invalid URL")
			return
		}
		
		guard let user = userManager.user else {
			print("Error: Invalid User")
			return
		}
		
		let token = user.token
		let newTask = NewTask(description: description, dueDate: jsonDateFormatter(dueDate))
		
		guard let jsonData = try? JSONEncoder().encode(newTask) else {
			print("Error: Trying to convert newTask into JSON Data")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let (data, _) = try! await URLSession.shared.data(for: request)
		let task = try! JSONDecoder().decode(TaskUnity.self, from: data)
		print("Task: \(task)")
		tasks.append(task)
	}
			
	func jsonDateFormatter(_ stringDate: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		let date = dateFormatter.date(from: stringDate)
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime]
		let isoDate = isoFormatter.string(from: date!)
		return isoDate
	}
}

enum AddTask: Error {
	case invalidURL
	case invalidResponse
	case invalidData
	case invalidUser
	case encodingNewTask
}

//MARK: View
struct AddTaskView: View {
	@State var description: String
	@State var dueDate: String
	
	@ObservedObject var addTaskViewModel: AddTaskViewModel
	
	init(viewModel: AddTaskViewModel) {
		let description = "Water the plants"
		let dueDate = "25-11-2024"
		self.addTaskViewModel = viewModel
		self.description = description
		self.dueDate = dueDate
	}
	
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
			}
			Button {
				Task {
					do {
						try await addTaskViewModel.addNewTask(description: description, dueDate: dueDate)
					} catch {
						print("Error: couldn't add new task")
					}
				}
			} label: {
				Text("Add Task")
			}
			.buttonStyle(.borderedProminent)
		}
	}
}

//#Preview {
//	AddTaskView(viewModel: AddTaskViewModel(userManager: UserManager()))
//}
