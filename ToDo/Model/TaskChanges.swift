import Foundation

struct TaskChanges: Encodable {
	let description: String
	let dueDate: String
	
	init(description: String, dueDate: String) {
		self.description = description
		self.dueDate = dueDate
	}
	
	init(description: String) {
		self.description = description
		dueDate = ""
	}
	
	init(dueDate: String) {
		description = ""
		self.dueDate = dueDate
	}
}
