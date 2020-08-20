//
//  ViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 19/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        let newItem1 = Item();
        newItem1.title = "Find Mike";
        itemArray.append(newItem1);
        
        let newItem2 = Item();
        newItem2.title = "Buy Eggos";
        itemArray.append(newItem2);
        
        let newItem3 = Item();
        newItem3.title = "Defeat Demigorgan";
        itemArray.append(newItem3);
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items;
//        }
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
        
        self.saveItems();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            let newItem = Item()
            newItem.title = textField.text!;
            
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
        let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(itemArray);
            try data.write(to: dataFilePath!);
        } catch {
            print("error encoding");
        }
        
        self.tableView.reloadData();
    }
}

