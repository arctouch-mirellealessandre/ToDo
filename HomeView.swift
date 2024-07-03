//
//  HomeView.swift
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

extension TaskUnity {
	func userDateFormatter() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: self.dueDate)
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withFullDate]
		let isoDate = isoFormatter.string(from: date!)
		return isoDate
	}
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
		request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let (data, _) = try! await URLSession.shared.data(for: request)
		let tasks = try! JSONDecoder().decode([TaskUnity].self, from: data)
		
		return tasks
	}
}

//MARK: View
struct HomeView: View {
	@ObservedObject var homeViewModel: HomeViewModel
	
	init(viewModel: HomeViewModel) {
		self.homeViewModel = viewModel
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				List {
					ForEach(homeViewModel.tasks, id: \.id) { task in
						TaskListRowView(task: task)
					}
				}
			}
			NavigationLink(destination: {
				AddTaskView(viewModel: AddTaskViewModel(userManager: homeViewModel.userManager, tasks: homeViewModel.tasks))
			}, label: {
				Text("Add New Task")
			})
			.buttonStyle(.borderedProminent)
			.task {
				do {
					homeViewModel.tasks = try await homeViewModel.requestTasks()
				} catch {
					print("Couldn't request tasks")
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("All My Tasks")
						.font(.largeTitle.bold())
						.accessibilityAddTraits(.isHeader)
				}
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
			Text("Due on \(task.userDateFormatter())")
		})
		.padding()
	}
}

#Preview {
	HomeView(viewModel: HomeViewModel(userManager: UserManager()))
}
