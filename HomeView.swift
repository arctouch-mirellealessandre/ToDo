import SwiftUI

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

