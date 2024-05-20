//
//  LoginPostRequest.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 13/05/24.
//

import Foundation

struct PostLogin {
	func postLoginRequest(username: String, password: String) async throws -> User {
		
		guard let url = URL(string: "http://0.0.0.0:8080/v1/users/login") else {
			throw LoginRequest.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		//pq data é uma optiona?
		//o que é .utf8
		let basicAuth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
		request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
		
		let (data, response) = try! await URLSession.shared.data(for: request)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw LoginRequest.invalidResponse
		}
		
		let user = try? JSONDecoder().decode(User.self, from: data)
		
		return user
	}
}

//final class PokemonService {
//	
//	func requestList(from url: String) async -> [Pokemon] {
//		
//		guard let url = URL(string: url) else {
//			return []
//		}
//
//		let (data, response) = try! await URLSession.shared.data(from: url)
//		
//		let array = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]) ?? []
//		let pokemon = array.map { Pokemon(from: $0) }
//		
//		return pokemon
//	}
//}

enum LoginRequest: Error {
	case invalidURL
	case invalidResponse
}
