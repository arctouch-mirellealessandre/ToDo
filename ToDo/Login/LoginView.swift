//
//  LoginView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 23/05/24.
//

import SwiftUI

final class UserManager: ObservableObject {
	@Published var userState: UserState = .none
}

struct LoginView: View {
	@State private var username: String
	@State private var password: String
	private var userManager: UserManager
	
	init(userManager: UserManager) {
		self.username = ""
		self.password = ""
		self.userManager = userManager
	}
	
    var body: some View {
		VStack {
			Text("Login")
				.bold()
				.font(.largeTitle)
			Form {
				TextField("Username", text: $username)
					.textInputAutocapitalization(.never)
				TextField("Password", text: $password)
					.textInputAutocapitalization(.never)
				}
			Button {
				Task {
					let user = try await PostLogin().postLoginRequest(username: username, password: password)
					if user != nil {
						userManager.userState = .authorized
					}
				}
			} label: {
				Text("Login")
			}
		}
    }
}

enum UserState {
	case none
	case authorized
}

#Preview {
	LoginView(userManager: UserManager())
}
