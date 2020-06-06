//
//  TodoView.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 01.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct TodoView: View {
    
    // Connection to the ViewModel (Todo)
    @EnvironmentObject var todo: Todo
    
    
    // UI content and layout
    // ---------------------
    
    var body: some View {
        NavigationView {
            ZStack {
                ListView()
                    .navigationBarTitle("Todo")
                
                NewItemButton()

            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView().environmentObject(Todo())
    }
}
