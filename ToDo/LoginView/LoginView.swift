//
//  LoginView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 23/05/24.
//

import SwiftUI

struct User: Codable {
	var firstName: String
	var email: String
	var username: String
	var id: String
	var lastName: String
	var token: String
}

final class UserManager: ObservableObject {
	@Published var userState: UserState = .none
	@Published var user: User?
}

final class LoginViewModel: ObservableObject {
	private var userManager: UserManager
	private var user: User?
	
	init(userManager: UserManager) {
		self.userManager = userManager
		self.user = nil
	}
	
	func postLoginRequest(username: String, password: String) async throws -> User? {
		guard let url = URL(string: "http://0.0.0.0:8080/v1/users/login") else {
			throw LoginRequest.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		let basicAuth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
		request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
		
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw LoginRequest.invalidResponse
		}
	
		let user = try JSONDecoder().decode(User.self, from: data)
		userManager.user = user
		userManager.userState = .authorized
		return user
	}
}

struct LoginView: View {
	@State private var username: String
	@State private var password: String
	
	@ObservedObject private var loginViewModel: LoginViewModel
	
	init(loginViewModel: LoginViewModel) {
		self.username = "john.doe"
		self.password = "123456789"
		self.loginViewModel = loginViewModel
	}
	
	var body: some View {
		VStack {
			Text("Login")
				.bold()
				.font(.largeTitle)
			Form {
				Section() {
					TextField("", text: $username)
						.textInputAutocapitalization(.never)
				} header: {
					Text("Username")
				}
				Section() {
					TextField("", text: $password)
						.textInputAutocapitalization(.never)
				} header: {
					 Text("Password")
				}
			}
			Button("Login") {
				Task {
					_ = try await loginViewModel.postLoginRequest(username: username, password: password)
				}
			}
			.buttonStyle(.borderedProminent)
		}
	}
}

enum LoginRequest: Error {
	case invalidURL
	case invalidResponse
}

enum UserState {
	case none
	case authorized
}

#Preview {
	LoginView(loginViewModel: LoginViewModel(userManager: UserManager()))
}