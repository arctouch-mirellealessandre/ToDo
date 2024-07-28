import Foundation

struct NewTask: Codable {
	let description: String
	let dueDate: String
	
	init(description: String, dueDate: String) {
		self.description = description
		self.dueDate = dueDate
	}
}
