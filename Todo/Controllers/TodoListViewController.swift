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
    
    let defaults = UserDefaults();

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
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
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
        
        tableView.reloadData();
        
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
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray");
            
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
}

