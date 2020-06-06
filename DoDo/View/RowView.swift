//
//  RowView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 02.05.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct RowView: View {
    
    // Environment variables
    // ---------------------
    
    // Connection to the ViewModel (Todo)
    @EnvironmentObject var todo: Todo
    // Color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // State variables
    // ---------------
    // is item edit view presented?
    @State var sheetIsPresented = false
    // is item dragged enought to be deleted?
    @State var readyToBeDeleted = false
    // is alert presented?
    @State var alertIsPresented = false
    // is current item deleted?
    @State var deleting = false
    // drag gesture state
    @State var viewState = CGSize.zero
    // is long press finished?
    @State var completedLongPress = false
    // is user currently pressing
    @GestureState var isDetectingLongGesture = false
    
    // Other variables
    // ---------------
    
    // how much user should drag item to delete it
    var valueToBeDeleted: CGFloat = -75
    
    // unique id of item
    var itemId: UUID
    
    // item from model (if found)
    var item: TodoItem? {
        return todo.getItemById(itemId: itemId)
    }
    
    
    // UI content and layout
    // ---------------------
    
    var body: some View {
        // Layout
        HStack {
            Image(systemName: item?.isDone ?? false ? "circle.fill" : "circle")
                .font(.system(size: 10, weight: .black))
                .padding(.trailing, 10)
                .foregroundColor(Color(item?.colorName ?? "blue"))

            Text(item?.title ?? "Sample Note")
                .foregroundColor(.primary)
            Spacer()
        }
            
        // Visual properties
        .padding(20)
        .background(self.readyToBeDeleted ? Color(.systemRed) : (colorScheme == .light ? Color(item?.colorName ?? "blue").opacity(0.2) : Color(.systemGray6)))
        .cornerRadius(20)
        
        // UI responces
        .offset(x: self.viewState.width < 0 ? self.viewState.width : 0)
        .scaleEffect(
            (self.isDetectingLongGesture || self.viewState.width < 0) ? 0.95 : (self.deleting ? 0 : 1))
            
        .animation(.default)
            
        // Gestures
        // --------
            
        // Long press
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .updating($isDetectingLongGesture) { currentstate, gestureState, transaction in
                    gestureState = currentstate
                }
                .onEnded { finished in
                    self.sheetIsPresented = true
                }
        )
        
        // Drag
        .gesture(
            DragGesture()
                .onChanged { value in
                    self.viewState = value.translation
                    self.readyToBeDeleted = self.viewState.width < self.valueToBeDeleted ? true : false
                }
                .onEnded { _ in
                    if self.viewState.width < self.valueToBeDeleted {
                        self.alertIsPresented = true
                    }
                    self.viewState = .zero
                    self.readyToBeDeleted = false
                }
        )
            
        // Tap
        .gesture(
            LongPressGesture(minimumDuration: 0).onEnded {_ in self.todo.toggleItem(itemId: self.itemId)})
            
        // Modals
        // ------
            
        // Deletion approval
        .alert(isPresented: self.$alertIsPresented) {
            Alert(
                title: Text("Delete task"),
                message: Text("This action cannot be undone"),
                primaryButton: .destructive(Text("Yes"), action: {
                    self.deleting = true
                    self.todo.deleteItem(itemId: self.itemId)
                }),
                secondaryButton: .cancel())
        }
        
        // Edit item modal
        .sheet(isPresented: self.$sheetIsPresented, onDismiss: {self.sheetIsPresented = false }) {
            EditItemView(todo: self.todo, todoItem: self.item ?? TodoItem(title: "Error"))
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(itemId: UUID()).environmentObject(Todo())
    }
}
