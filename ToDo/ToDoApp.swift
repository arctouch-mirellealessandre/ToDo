import SwiftUI

@main
struct ToDoApp: App {
	@ObservedObject var userManager: UserManager
	@ObservedObject var taskService: TaskService
	@ObservedObject var loginViewModel: LoginViewModel
	@ObservedObject var homeViewModel: HomeViewModel

	init() {
		let userManager = UserManager()
		let taskService = TaskService(userManager: userManager)
		self.userManager = userManager
		self.taskService = taskService
		self.loginViewModel = LoginViewModel(userManager: userManager, taskService: taskService)
		self.homeViewModel = HomeViewModel(taskService: taskService)
	}
		
	var body: some Scene {
		WindowGroup {
			if userManager.userState == .authorized {
				HomeView(viewModel: homeViewModel)
			} else {
				LoginView(viewModel: loginViewModel)
			}
		}
	}
}
