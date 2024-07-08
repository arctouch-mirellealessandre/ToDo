//
//  LoginView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 23/05/24.
//

import SwiftUI

enum LoginRequest: Error {
	case invalidURL
	case invalidResponse
}

@MainActor
final class LoginViewModel: ObservableObject {
	private var userManager: UserManager
	
	init(userManager: UserManager) {
		self.userManager = userManager
	}
	
	func postLoginRequest(_ username: String, _ password: String) async throws {
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
		
		userManager.user = try JSONDecoder().decode(User.self, from: data)
		userManager.updateUserState()
	}
	
	func requestLogin(_ username: String, _ password: String) {
		Task {
			do {
				try await postLoginRequest(username, password)
			} catch {
				print("Login attempt failed.")
			}
		}
		
	}
}

struct LoginView: View {
	@State private var username: String
	@State private var password: String
	@ObservedObject var loginViewModel: LoginViewModel

	init(viewModel: LoginViewModel) {
		self.username = "john.doe"
		self.password = "123456789"
		self.loginViewModel = viewModel
	}

	var body: some View {
		VStack {
			Text("Login")
				.bold()
				.font(.largeTitle)
		}
		ZStack {
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
				loginViewModel.requestLogin(username, password)
				}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			}
		}
}

//#Preview {
//	LoginView(loginViewModel: LoginViewModel(userManager: UserManager()))
//}
