import SwiftUI

struct DeleteTaskView: View {
	var task: TaskUnity
	var deleteTaskViewModel: DeleteTaskViewModel
	
	init(task: TaskUnity, deleteTaskViewModel: DeleteTaskViewModel) {
		self.task = task
		self.deleteTaskViewModel = deleteTaskViewModel
	}
	
	var body: some View {
		Image(systemName: "xmark.bin.circle.fill")
			.foregroundStyle(.red)
			.font(.system(size: 22))
			.onTapGesture {
				deleteTaskViewModel.deleteTask(task)
			}
	}
}
