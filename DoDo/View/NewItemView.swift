//
//  NewItemView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 25.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct NewItemView: View {
    var todo: Todo
    
    @State var newItemTitle = ""
    @State var newItemColor = "blue"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("New task")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    let newItem = TodoItem(title: self.newItemTitle, colorName: self.newItemColor)
                    self.todo.addItem(newItem: newItem)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Apply")
                        .fontWeight(.medium)
                }
                .disabled(newItemTitle.count == 0)
            }
            .padding([.top, .horizontal])
                
            TextField("New Task", text: $newItemTitle)
                .font(.system(size: 20))
                .padding(20)
                .background(Color(.systemGray5))
                .cornerRadius(20)
                                    .padding(.bottom)
            
            ColorPickerView(choosenColor: self.$newItemColor)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Swipe down to cancel")
                    .foregroundColor(.secondary)
                    .padding(.top)
                Spacer()
            }
        }
        .padding(25)
        .navigationBarItems(
            trailing: Button(action: {
                let newItem = TodoItem(title: self.newItemTitle)
                self.todo.addItem(newItem: newItem)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            }
        )
    }
}



struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(todo: Todo())
    }
}
