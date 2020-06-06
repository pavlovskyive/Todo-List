//
//  NewItemView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 25.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct NewItemView: View {
    
    // Property
    // --------
       
    // Connection to the ViewModel (Todo)
    var todo: Todo
    
    // State variables
    // ---------------
    // new item title
    @State var newItemTitle = ""
    // new item color
    @State var newItemColor = "blue"
    
    // Environment variables
    // ---------------------
    // variable for dissmission of modal sheet
    @Environment(\.presentationMode) var presentationMode
    
    
    // UI content and layout
    // ---------------------
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Header
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
                
            // Input
            TextField("New Task", text: $newItemTitle)
                .font(.system(size: 20))
                .padding(20)
                .background(Color(.systemGray5))
                .cornerRadius(20)
                                    .padding(.bottom)
            
            ColorPickerView(choosenColor: self.$newItemColor)
            
            Spacer()
            
            // Footer
            HStack {
                Spacer()
                Text("Swipe down to cancel")
                    .foregroundColor(.secondary)
                    .padding(.top)
                Spacer()
            }
        }
        .padding(25)
    }
}



struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(todo: Todo())
    }
}
