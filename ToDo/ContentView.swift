//
//  ContentView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 09/05/24.
//

import SwiftUI

struct ContentView: View {
	@State private var username = ""
	@State private var password = ""
	
	var body: some View {
		VStack {
			Text("Login")
				.bold()
				.font(.largeTitle)
			
			Form {
				TextField("Username", text: $username)
				TextField("Password", text: $password)
			}
			
			Button(action: {
				PostLogin().postLoginRequest(username: username, password: password)
			}, label: {
				Text("Login")
			})
			.padding()
        }
    }
}

#Preview {
    ContentView()
}
