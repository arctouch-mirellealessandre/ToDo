import Foundation

enum UserState {
	case none
	case authorized
}

final class UserManager: ObservableObject {
	@Published var userState: UserState = .none
	@Published var user: User?
	
	func updateUserState() {
		if let _ = user {
			userState = .authorized
		}
	}
	
}

