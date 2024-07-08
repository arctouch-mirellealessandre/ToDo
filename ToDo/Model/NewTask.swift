//
//  NewTask.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 05/07/24.
//

import Foundation

struct NewTask: Codable {
	let description: String
	let dueDate: String
	
	init(description: String, dueDate: String) {
		self.description = description
		self.dueDate = dueDate
	}
}
