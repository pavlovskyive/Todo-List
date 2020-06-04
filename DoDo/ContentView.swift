//
//  ContentView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 01.06.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isChecked: Bool = false
}

struct ToDoView: View {
    @State var todos = [
        TodoItem(title: "Study"),
        TodoItem(title: "Finish App"),
        TodoItem(title: "Do Yoga"),
        TodoItem(title: "Meditate"),
        TodoItem(title: "Workout"),
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todos) { item in
                    HStack {
                        Image(systemName: item.isChecked ? "checkmark.circle" : "circle")
                        Text(item.title)
                        Spacer()
                    }
                    .background(Color(.systemBackground))
                    .onTapGesture {
                        if let matchingIndex = self.todos.firstIndex(where: { $0.id == item.id }) {
                            self.todos[matchingIndex].isChecked.toggle()
                        }
                    }
                }
                .onDelete(perform: deleteListItem)
                .onMove(perform: moveListItem)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle("Checklist")
        }
    }
    
    func deleteListItem(whichElement: IndexSet) {
        todos.remove(atOffsets: whichElement)
    }
    
    func moveListItem(whichElement: IndexSet, destination: Int) {
        todos.move(fromOffsets: whichElement, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
