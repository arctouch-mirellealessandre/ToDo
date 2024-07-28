import Foundation

struct TaskUnity: Codable, Equatable, Hashable {
	var dueDate: String
	var description: String
	let id: String
	var completed: Bool
}

extension TaskUnity {
	func changeDateFormatToUser() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: self.dueDate)
		
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withFullDate]
		let isoDate = isoFormatter.string(from: date!)
		return isoDate
	}	
}
