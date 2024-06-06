//
//  MainView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 03/06/24.
//

import SwiftUI

//Model
struct TaskUnity {
	var dueDate: String
	var description: String
	let id: String
	var isCompleted: Bool
}

//ViewModel
final class MainViewModel: ObservableObject {
	
	var task = TaskUnity(dueDate: "04/06/2024", description: "Do laundry", id: "001", isCompleted: true)
	
	@Published private var tasks: [TaskUnity] = []
}

//View
struct MainView: View {
	
	@StateObject var viewModel: MainViewModel
	
    var body: some View {
		VStack {
			Text("All My Tasks")
				.font(.title)
				.bold()
				.padding()
			task
			
		}
		Spacer()
    }
	
	var task: some View {
		VStack(alignment: .leading, content: {
			HStack {
				Text(viewModel.task.description)
					.font(.title2)
					.bold()
				Spacer()
				Image(systemName: viewModel.task.isCompleted ? "checkmark.circle.fill" : "circle")
					.foregroundStyle(viewModel.task.isCompleted ? .green : .gray)
					.font(.system(size: 22))
					.onTapGesture {
						viewModel.task.isCompleted.toggle()
					}
			}
			Text("Due on: \(viewModel.task.dueDate)")
		})
		.padding()
	}
}

#Preview {
	MainView(viewModel: MainViewModel())
}
