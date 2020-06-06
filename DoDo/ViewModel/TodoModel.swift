//
//  ViewModel.swift
//  ToDo
//
//  Created by Vsevolod Pavlovskyi on 03.04.2020.
//  Copyright © 2020 Vsevolod Pavlovskyi. All rights reserved.
//

import Foundation
import Combine


// ViewModel: Link between model and view,
// handling actions of user input about data
class Todo: ObservableObject {
    
    // Properties
    // ----------
    
    // Array of items of todo list,
    // every time updated sends didChange to every view subscribed to it.
    @Published var items = [TodoItem] ()
    
    // Methods
    // -------
    init() {
        loadItems()
    }
    
    // Write data to local storage
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error writing items to file: \(error.localizedDescription)")
        }
    }
    
    // Loading data from local storage
    func loadItems() {
        let path = dataFilePath()
        
        // If no data this is skipped
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error reading items: \(error.localizedDescription)")
            }
        }
    }
    
    // Struct is not a reverence value, meaning we can't pass items themselves.
    // So we operating with them via ids.
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
    
    // Get Document directory path on device
    func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Get path to plist data file
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Todo.plist")
    }
}

// All colors we implemented in assets.
// Can be expanded: add color to assets and add here its name.
// Everything will be handled automatically.
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
