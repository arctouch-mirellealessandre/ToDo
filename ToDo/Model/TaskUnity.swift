//
//  TaskUnity.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 05/07/24.
//

import Foundation

struct TaskUnity: Codable, Equatable {
	var dueDate: String
	var description: String
	let id: String
	var completed: Bool
}

extension TaskUnity {
	func userDateFormatter() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: self.dueDate)
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withFullDate]
		let isoDate = isoFormatter.string(from: date!)
		return isoDate
	}
}
