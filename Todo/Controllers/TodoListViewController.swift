//
//  ViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 19/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems();
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        
        cell.textLabel?.text = item.title;
        
        cell.accessoryType = item.done ? .checkmark : .none;
        
        return cell;
    }

    // MARK: - UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        
//        context.delete(itemArray[indexPath.row]);
//        itemArray.remove(at: indexPath.row);

        
        self.saveItems();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            let newItem = Item(context: self.context);
            newItem.title = textField.text!;
            newItem.done = false;
            
            self.itemArray.append(newItem);
            
            self.saveItems();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    // MARK: - Save Items
    
    func saveItems() {
        do {
            try context.save();
        } catch {
            print("error saving data \(error)");
        }
        
        self.tableView.reloadData();
    }
    
    // MARK: - Load Items

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
           itemArray = try context.fetch(request);
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData();
    }
    
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest();
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        
        loadItems(with: request);
    }
}

