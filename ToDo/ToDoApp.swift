//
//  ToDoApp.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 09/05/24.
//

import SwiftUI

@main
struct ToDoApp: App {
	
	@StateObject var userManager = UserManager()
	
    var body: some Scene {
        WindowGroup {
			if userManager.userState == .authorized {
				MainView()
			} else {
				LoginView(userManager: userManager)
			}
        }
    }
}
