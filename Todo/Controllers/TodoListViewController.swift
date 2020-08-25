//
//  ViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 19/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var items: Results<Item>?;
    
    let realm = try! Realm();
    
    var selectedCategory: Category? {
        didSet{
            loadItems();
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items?[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        
        cell.textLabel?.text = item?.title ?? "No Items Have Been Added";
        
        cell.accessoryType = (item?.done ?? false) ? .checkmark : .none;
        
        return cell;
    }

    // MARK: - UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done;
                }
            } catch {
                print("Error saving item \(error)");
            }
            
        }
        
        self.tableView.reloadData();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item();
                        newItem.title = textField.text!;
                        currentCategory.items.append(newItem);
                    }
                } catch {
                    print("Error saving items \(error)");
                }
            }
            
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    // MARK: - Load Items

    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true);
        tableView.reloadData();
    }
    
}

// MARK: - Search Bar Delegate Methods

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest();
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
//
//        loadItems(with: request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!));
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems();
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder();
//            }
//        }
//    }
//}

