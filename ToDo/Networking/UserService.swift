//
//  UserService.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 05/07/24.
//

import Foundation

struct User: Codable {
	var firstName: String
	var email: String
	var username: String
	var id: String
	var lastName: String
	var token: String
}
