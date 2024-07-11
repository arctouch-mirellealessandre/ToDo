//
//  UpdateTaskView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 11/07/24.
//

import SwiftUI

//MARK: Model


//MARK: ViewModel
class UpdateTaskViewModel: ObservableObject {
	var taskService: TaskService
	
	init(taskService: TaskService) {
		self.taskService = taskService
	}
	
	func updateTask(_ name: String, _ id: String) {
		
	}
}

//MARK: View
struct UpdateTaskView: View {
	@State var newName = ""
	@State var newDate = ""
	@ObservedObject var updateTaskViewModel: UpdateTaskViewModel
	
    var body: some View {
		VStack {
			Form() {
				Section {
					TextField("Description", text: $newName)
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
				updateTaskViewModel.updateTask(<#String#>, <#String#>)
			} label: {
				Text("Update task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -480)
		}
    }
}

#Preview {
    UpdateTaskView(updateTaskViewModel: UpdateTaskViewModel(taskService: TaskService(userManager: UserManager())))
}
