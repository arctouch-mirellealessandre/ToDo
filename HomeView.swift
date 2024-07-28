import SwiftUI

//MARK: ViewModel
@MainActor
final class HomeViewModel: ObservableObject {
	@Published var tasks = [TaskUnity]()
	
	var taskService: TaskService
		
	init(taskService: TaskService) {
		self.taskService = taskService
	}
	
	func requestTasks() {
		Task {
			do {
				tasks = try await taskService.requestTasks()
			} catch {
				print("Couldn't request tasks")
			}
		}
	}
	
	func deleteTask(_ task: TaskUnity) {
		Task {
			do {
				let task = try await taskService.deleteTask(with: task.id)
				let taskIndex = tasks.firstIndex(of: task)
				
				guard let taskIndex = taskIndex else {
					print("Delete Task Method: couldn't remove task from the array")
					return
				}
				
				tasks.remove(at: taskIndex)
			} catch {
				print("Delete Task Method: couldn't delete task")
			}
		}
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
					ForEach(homeViewModel.tasks, id: \.self) { task in
						TaskListRowView(task: task, homeViewModel: homeViewModel)
					}
				}
			}
			NavigationLink(destination: {
				AddTaskView(viewModel: AddTaskViewModel(taskService: homeViewModel.taskService))
			}, label: {
				Text("Add New Task")
			})
			.buttonStyle(.borderedProminent)
			.task {
				homeViewModel.requestTasks()
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

private struct TaskListRowView: View {
	@State var task: TaskUnity
	@ObservedObject var homeViewModel: HomeViewModel
	
	init(task: TaskUnity, homeViewModel: HomeViewModel) {
		self.task = task
		self.homeViewModel = homeViewModel
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
			HStack {
				Text("Due on \(task.changeDateFormatToUser())")
				Spacer()
				Image(systemName: "xmark.bin.circle.fill")
					.foregroundStyle(.red)
					.font(.system(size: 22))
					.onTapGesture {
						homeViewModel.deleteTask(task)
					}
			}
			.offset(x: 0, y: 10)
			Spacer()
			NavigationLink("Edit", destination: UpdateTaskView(viewModel: UpdateTaskViewModel(taskService: homeViewModel.taskService, task: task)))
		})
		.padding()
	}
}

