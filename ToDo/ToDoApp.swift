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
	@ObservedObject var homeViewModel: HomeViewModel

	init() {
		let userManager = UserManager()
		self.userManager = userManager
		self.loginViewModel = LoginViewModel(userManager: userManager)
		self.homeViewModel = HomeViewModel(userManager: userManager)
	}
		
	var body: some Scene {
		WindowGroup {
			if userManager.userState == .authorized {
				HomeView(viewModel: homeViewModel)
			} else {
				LoginView(loginViewModel: loginViewModel)
			}
		}
	}
}
