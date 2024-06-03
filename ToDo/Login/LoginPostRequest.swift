//
//  LoginPostRequest.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 13/05/24.
//

import Foundation

struct PostLogin {	
	func postLoginRequest(username: String, password: String) async throws -> User? {
		
		guard let url = URL(string: "http://0.0.0.0:8080/v1/users/login") else {
			throw LoginRequest.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		let basicAuth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
		request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
		
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw LoginRequest.invalidResponse
		}
	
		let user = try JSONDecoder().decode(User.self, from: data)
		return user
	}
}


enum LoginRequest: Error {
	case invalidURL
	case invalidResponse
}
