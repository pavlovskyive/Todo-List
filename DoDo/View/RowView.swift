//
//  RowView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 02.05.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct RowView: View {
    @EnvironmentObject var todo: Todo
    @Environment(\.colorScheme) var colorScheme
    
    @State var sheetIsPresented = false
    @State var viewState = CGSize.zero
    @State var readyToBeDeleted = false
    @State var alertIsPresented = false
    
    // Long Press Gesture
    @GestureState var isDetectingLongGesture = false
    @State var completedLongPress = false
    
    @State var deleting = false
    
    var valueToBeDeleted: CGFloat = -75
    
    var itemId: UUID
    
    var item: TodoItem? {
        return todo.getItemById(itemId: itemId)
    }
    
    let shortPressGesture = LongPressGesture(minimumDuration: 0)
    .onEnded { _ in
        print("short press goes here")
    }
    
    var body: some View {
        HStack {
            Image(systemName: item?.isDone ?? false ? "circle.fill" : "circle")
                .font(.system(size: 10, weight: .black))
                .padding(.trailing, 10)
                .foregroundColor(Color(item?.colorName ?? "blue"))

            Text(item?.title ?? "Sample Note")
                .foregroundColor(.primary)
            Spacer()
        }
        // Visual
        .padding(20)
            .background(self.readyToBeDeleted ? Color(.systemRed) : (colorScheme == .light ? Color(item?.colorName ?? "blue").opacity(0.2) : Color(.systemGray6)))
        .background(Color(.systemGray6))
        .cornerRadius(20)
        
        // Responces
//        .overlay(Color(self.readyToBeDeleted ? .red : .clear).opacity(0.3).cornerRadius(20))
            
        .offset(x: self.viewState.width < 0 ? self.viewState.width : 0)
        .scaleEffect(
            (self.isDetectingLongGesture || self.viewState.width < 0) ? 0.95 : (self.deleting ? 0 : 1))
            
        .animation(.default)
            
        // Gestures
                
//        .onTapGesture(count: 1) {
//            self.todo.toggleItem(itemId: self.itemId)
//        }

        
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .updating($isDetectingLongGesture) { currentstate, gestureState, transaction in
                    gestureState = currentstate
                }
                .onEnded { finished in
                    self.sheetIsPresented = true
                }
        )
            
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
            
        .gesture(
            LongPressGesture(minimumDuration: 0).onEnded {_ in self.todo.toggleItem(itemId: self.itemId)})
            
        // Modals
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
