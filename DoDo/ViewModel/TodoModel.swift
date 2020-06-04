//
//  ViewModel.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 03.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import Foundation
import Combine

class Todo: ObservableObject {
    
    // Properties
    // ----------
    
    // Send updates forcing Views to update their contents
    var didChange = PassthroughSubject<Todo, Never>()
    
    // When will be loaded send notification to every View subscribed to NetworkManager
    // Connection to model
    @Published var items = [TodoItem] () {
        didSet {
            didChange.send(self)
        }
    }
    
    // Methods
    // -------
    init() {
        loadItems()
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error writing items to file: \(error.localizedDescription)")
        }
    }
    
    func loadItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error reading items: \(error.localizedDescription)")
            }
        }
    }
    
    func getItemById(itemId: UUID) -> TodoItem? {
        return items.first(where: { $0.id == itemId }) ?? nil
    }
    
    func addItem(newItem: TodoItem) {
        items.append(newItem)
        saveItems()
    }
    
    func deleteItem(itemId: UUID) {
        items.removeAll(where: {$0.id == itemId})
        saveItems()
    }
    
    func editItem(item: TodoItem) {
        if let id = items.firstIndex(where: { $0.id == item.id }) {
            items[id] = item
            saveItems()
        }
    }
    
    func toggleItem(itemId: UUID) {
        if let id = items.firstIndex(where: { $0.id == itemId }) {
            items[id].isDone.toggle()
            saveItems()
        }
    }
    
    func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Todo.plist")
    }
}

var colors = [
    "blue",
    "green",
    "indigo",
    "orange",
    "purple",
    "red",
    "teal",
    "yellow",
    "magenta",
]
