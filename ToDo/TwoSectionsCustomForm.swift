import SwiftUI

struct TwoSectionsCustomForm: View {
	@Binding var firstTextFieldText: String
	var firstHeaderText: String

	@Binding var secondTextFieldText: String
	var secondHeaderText: String

	var body: some View {
		Form {
			Section {
				TextField("", text: $firstTextFieldText)
					.textInputAutocapitalization(.never)
			} header: {
				Text(firstHeaderText)
			}
			Section {
				TextField("", text: $secondTextFieldText)
					.textInputAutocapitalization(.never)
			} header: {
				Text(secondHeaderText)
			}
		}
	}
}
