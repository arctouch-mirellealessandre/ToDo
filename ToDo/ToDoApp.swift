//
//  ToDoApp.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 09/05/24.
//

import SwiftUI

@main
struct ToDoApp: App {
	@ObservedObject var userManager: UserManager
	@ObservedObject var loginViewModel: LoginViewModel
	@ObservedObject var mainViewModel: HomeViewModel

	init() {
		let userManager = UserManager()
		self.userManager = userManager
		self.loginViewModel = LoginViewModel(userManager: userManager)
		self.mainViewModel = HomeViewModel(userManager: userManager)
	}
		
	var body: some Scene {
		WindowGroup {
			if userManager.userState == .authorized {
				HomeView(viewModel: mainViewModel)
			} else {
				LoginView(loginViewModel: loginViewModel)
			}
		}
	}
}
