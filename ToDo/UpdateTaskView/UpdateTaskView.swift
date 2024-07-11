//
//  UpdateTaskView.swift
//  ToDo
//
//  Created by Mirelle Alessandre on 11/07/24.
//

import SwiftUI

//MARK: Model


//MARK: ViewModel


//MARK: View
struct UpdateTaskView: View {
	@State var newName = ""
	@State var newDate = ""
	
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
				
			} label: {
				Text("Update task")
			}
			.buttonStyle(.borderedProminent)
			.offset(x: 0, y: -480)
		}
    }
}

#Preview {
    UpdateTaskView()
}
