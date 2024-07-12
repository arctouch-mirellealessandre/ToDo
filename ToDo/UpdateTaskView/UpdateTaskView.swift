//
//  UpdateTaskView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 11/07/24.
//

import SwiftUI

//MARK: Model
struct Changes: Encodable {
	let description: String
	let dueDate: String
}

//MARK: ViewModel
class UpdateTaskViewModel: ObservableObject {
	var taskService: TaskService
	var task: TaskUnity
	
	init(_ taskService: TaskService, _ task: TaskUnity) {
		self.taskService = taskService
		self.task = task
	}
	
	func updateTask(_ newDescription: String, _ newDueDate: String) {
		task.description = newDescription
		Task {
			do {
				task.dueDate = try await taskService.jsonDateFormatter(newDueDate)
				try await taskService.updateTask(task)
			} catch {
				print("UpdateTaskViewModel: something's wrong with updateTask method")
			}
		}
	}
}

//MARK: View
struct UpdateTaskView: View {
	@State var newDescription: String
	@State var newDate: String
	@ObservedObject var updateTaskViewModel: UpdateTaskViewModel
	
	init(_ updateTaskViewModel: UpdateTaskViewModel) {
		self.newDescription = "Listen to music"
		self.newDate = "12/07/2024"
		self.updateTaskViewModel = updateTaskViewModel
	}
	
    var body: some View {
		VStack {
			Form() {
				Section {
					TextField("Description", text: $newDescription)
				} header: {
					Text("Rename")
				}
				Section {
					TextField("Date", text: $newDate)
				} header: {
					Text("new date")
				}
			}
			Button {
				updateTaskViewModel.updateTask(newDescription, newDate)
			} label: {
				Text("Update task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -480)
		}
    }
}

//#Preview {
//    UpdateTaskView(updateTaskViewModel: UpdateTaskViewModel(taskService: TaskService(userManager: UserManager())))
//}
