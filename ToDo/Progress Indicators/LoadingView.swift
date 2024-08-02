import SwiftUI

struct LoadingView: View {
	var message: String
	
	init(message: String) {
		self.message = message
	}
	
	var body: some View {
		ZStack {
			Color(.systemBackground)
				.ignoresSafeArea()
			ProgressView(message+"...")
				.scaleEffect(1)
		}
	}
}
