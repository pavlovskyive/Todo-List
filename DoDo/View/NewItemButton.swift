//
//  NewItemButton.swift
//  TodoProj
//
//  Created by Vsevolod Pavlovskyi on 03.06.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct NewItemButton: View {
    // Connection to the ViewModel (Todo)
    @EnvironmentObject var todo: Todo
    
    // State variables
    // ---------------
    // is new item modal presented?
    @State var sheetIsPresented = false
    // is user currently pressing
    @GestureState var isDetectingLongGesture = false
    
    // Haptic feedback
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // UI content and layout
    // ---------------------
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundColor(.blue).opacity(0.1)
                        .frame(width: 100, height: 100)
                    Circle()
                        .foregroundColor(.blue).opacity(0.2)
                        .frame(width: 70, height: 70)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                .scaleEffect(self.isDetectingLongGesture ? 0.8 : 1)
                .animation(.spring())
            }
        }
        .padding(.bottom, 20)
        .padding(.trailing, 20)
            
        // Gestures
        // --------
            
        // Long Press
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .updating($isDetectingLongGesture) { currentstate, gestureState, transaction in
                    gestureState = currentstate
                }
                .onEnded {_ in
                    self.sheetIsPresented = true
                    self.hapticSuccess()
                }
        )
        
        // Tap
        .gesture(
            LongPressGesture(minimumDuration: 0)
                .onEnded {_ in
                    self.sheetIsPresented = true
                    self.hapticSuccess()
            }
        )
            
        // Modal (for new item view)
        .sheet(isPresented: self.$sheetIsPresented) {
            NewItemView(todo: self.todo)
        }
    }
}

struct NewItemButton_Previews: PreviewProvider {
    static var previews: some View {
        NewItemButton().environmentObject(Todo())
    }
}
