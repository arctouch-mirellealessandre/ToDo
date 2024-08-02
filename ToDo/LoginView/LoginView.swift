import SwiftUI

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
			Button {
				loginViewModel.isLoading = true
				loginViewModel.requestLogin(username, password)
			} label: {
				Text("Login")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -100)
			
			if loginViewModel.isLoading {
				LoadingView(message: "Loading")
			}
		}
	}
}
