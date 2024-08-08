import SwiftUI

struct LoginView: View {
	@State private var username: String
	@State private var password: String
	@ObservedObject private var loginViewModel: LoginViewModel
	
	private var loadingMessage = "Loading..."
	
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
			TwoSectionsCustomForm(
				firstTextFieldText: $username,
				firstHeaderText: "Username",
				secondTextFieldText: $password,
				secondHeaderText: "Password")
			Button {
				loginViewModel.isLoading = true
				loginViewModel.requestLogin(username, password)
			} label: {
				Text("Login")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			
			if loginViewModel.isLoading {
				LoadingView(message: loadingMessage)
			}
		}
	}
}
