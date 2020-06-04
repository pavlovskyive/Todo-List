//
//  ListView.swift
//  TodoProj
//
//  Created by Vsevolod Pavlovskyi on 02.05.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var todo: Todo
    
    @State var itemForEdit = TodoItem(title: "")
    
    var body: some View {
        List{
            ForEach(self.todo.items.sorted(by: { $0.colorName < $1.colorName})) { item in
                RowView(itemId: item.id)
            }
        }
        .animation(.default)
        .onAppear() {
            UITableView.appearance().separatorColor = .clear
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(Todo())
    }
}
