//
//  MainView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 03/06/24.
//

import SwiftUI

//MARK: Model
struct TaskUnity: Codable {
	var dueDate: String
	var description: String
	let id: String
	var completed: Bool
}

//MARK: ViewModel
final class HomeViewModel: ObservableObject {
	@Published var tasks = [TaskUnity]()
	var userManager: UserManager
		
	init(userManager: UserManager) {
		self.userManager = userManager
	}

	func requestTasks() async throws -> [TaskUnity] {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/tasks"), let user = userManager.user else {
			return []
		}
		let token = user.token
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
		let (data, _) = try! await URLSession.shared.data(for: request)
		let tasks = try! JSONDecoder().decode([TaskUnity].self, from: data)
		return tasks
	}
}

//MARK: View
struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				List {
					ForEach(viewModel.tasks, id: \.id) { task in
						TaskListRowView(task: task)
					}
				}
			}
			NavigationLink(destination: {
				AddTaskView(viewModel: AddTaskViewModel(userManager: viewModel.userManager))
			}, label: {
				Text("Add New Task")
			})
			.buttonStyle(.borderedProminent)
		}
		.navigationTitle("All My Tasks")
		.task {
			do {
				viewModel.tasks = try await viewModel.requestTasks()
			} catch {
				print("Couldn't request tasks")
			}
		}
	}
}

struct TaskListRowView: View {
	@State var task: TaskUnity
	
	init(task: TaskUnity) {
		self.task = task
	}
	
	var body: some View {
		VStack(alignment: .leading, content: {
			HStack {
				Text(task.description)
					.font(.title2)
					.bold()
				Spacer()
				Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
					.foregroundStyle(task.completed ? .green : .gray)
					.font(.system(size: 22))
					.onTapGesture {
						task.completed.toggle()
					}
			}
			Text("Due on: \(task.dueDate)")
		})
		.padding()
	}
}

#Preview {
	HomeView(viewModel: HomeViewModel(userManager: UserManager()))
}
