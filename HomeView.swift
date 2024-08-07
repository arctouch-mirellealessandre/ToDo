import SwiftUI

struct HomeView: View {
	@ObservedObject private var homeViewModel: HomeViewModel
	
	private var loadingMessage = "Requesting tasks..."
	
	init(viewModel: HomeViewModel) {
		self.homeViewModel = viewModel
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack {
					List {
						ForEach(homeViewModel.tasks, id: \.self) { task in
							TaskListRowView(task: task, homeViewModel: homeViewModel)
						}
					}
					NavigationLink(destination: {
						AddTaskView(viewModel: AddTaskViewModel(taskService: homeViewModel.taskService))
					}, label: {
						Text("Add New Task")
					})
					.buttonStyle(.borderedProminent)
				}
				if homeViewModel.isRequestingTasks {
					LoadingView(message: loadingMessage)
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
			.task {
				homeViewModel.isRequestingTasks = true
				homeViewModel.requestTasks()
			}
		}
	}
}

private struct TaskListRowView: View {
	@State var task: TaskUnity
	//TODO: Por que esse homeViewModel é um ObservedObject aqui?
		//porque precisamos observar as mudanças que ocorrem em tasks ?
	@ObservedObject private var homeViewModel: HomeViewModel
	
	private var deleteTaskViewModel: DeleteTaskViewModel
	
	init(task: TaskUnity, homeViewModel: HomeViewModel) {
		self.task = task
		self.homeViewModel = homeViewModel
		self.deleteTaskViewModel = DeleteTaskViewModel(taskService: homeViewModel.taskService, homeViewModel: homeViewModel)
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
				DeleteTaskView(task: task, deleteTaskViewModel: deleteTaskViewModel)
			}
			.offset(x: 0, y: 10)
			Spacer()
			NavigationLink("Edit", destination: UpdateTaskView(viewModel: UpdateTaskViewModel(taskService: homeViewModel.taskService, task: task)))
		})
		.padding()
	}
}
