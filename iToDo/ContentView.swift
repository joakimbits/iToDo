//
//  ContentView.swift
//  iToDo
//
//  Created by Joakim Pettersson on 2024-11-21.
//

//
//  ContentView.swift
//  Moderna_Swift_4
//
//  Created by Joakim Pettersson on 2024-11-08.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.createdAt, order: .reverse) private var initialTasks: [Item]
    @State private var tasks: [Item] = []

    var body: some View {
        VStack {
            TaskSection(title: "Ogjorda uppgifter", tasks: $tasks, isDone: false, modelContext: modelContext)

            Spacer()

            if tasks.contains(where: { $0.isDone }) {
                Button(action: deleteAllDoneTasks) {
                    Text("Radera alla gjorda uppgifter")
                        .foregroundColor(.red)
                }
                .padding(.bottom, 8)
            }

            TaskSection(title: "Gjorda uppgifter", tasks: $tasks, isDone: true, modelContext: modelContext)
        }
        .padding()
        .onAppear {
            tasks = initialTasks
        }
    }

    private func deleteAllDoneTasks() {
        for todo in tasks where todo.isDone {
            modelContext.delete(todo)
        }
        try? modelContext.save()

        tasks.removeAll { $0.isDone }
    }

}


struct TaskSection: View {
    var title: String
    @Binding var tasks: [Item]
    var isDone: Bool
    var modelContext: ModelContext

    @State private var newTaskTitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !isDone {
                HStack {
                    TextField("Lägg till uppgift...", text: $newTaskTitle)
                        .onSubmit {
                            addNewTask(title: newTaskTitle)
                            newTaskTitle = ""
                        }
                }
                .padding(.bottom, 4)
            }

            ForEach(tasks.filter { $0.isDone == isDone }) { task in
                HStack {
                    TextField("Uppgift...", text: Binding(
                        get: { task.title },
                        set: { newValue in
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks[index].title = newValue
                            }
                        }
                    ))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isDone ? .green : .red)
                        .onTapGesture {
                            toggleTaskStatus(task)
                        }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func addNewTask(title: String) {
        guard !title.isEmpty else { return }
        let newTask = Item(title: title, isDone: false, createdAt: Date())
        
        // Insert the new todo at the start of the todos array
        tasks.insert(newTask, at: 0) // Insert at the head of the array
        modelContext.insert(newTask) // Also add to the database
    }


    private func toggleTaskStatus(_ task: Item) {
        task.isDone.toggle() // Directly toggle the isDone property
        // Save the context if needed
        try? modelContext.save() // Save changes to the database
    }
}
