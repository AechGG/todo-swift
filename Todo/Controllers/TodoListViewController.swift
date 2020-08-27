//
//  ViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 19/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?;
    
    let realm = try! Realm();
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItems();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 80.0;
        
        tableView.separatorStyle = .none;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name;
            
            if let safeColor = UIColor(hexString: colorHex) {
                navigationController?.navigationBar.barTintColor = safeColor;
                
                navigationController?.navigationBar.tintColor = ContrastColorOf(safeColor, returnFlat: true);
                
                navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(safeColor, returnFlat: true)]
                
                searchBar.barTintColor = safeColor;
            }
            
            
        }
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items?[indexPath.row];
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        
        if let safeItem = item, let safeColor = UIColor(hexString: selectedCategory?.color ?? "1D9BF6") {
            cell.backgroundColor = safeColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count));
            
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true);
            
            cell.textLabel?.text = safeItem.title;
            
            cell.accessoryType = safeItem.done ? .checkmark : .none;
        } else {
            cell.textLabel?.text = "No Items Have Been Added";
            
            cell.accessoryType = .none;
        }
        
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
                        newItem.dateCreated = Date();
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
    
    // MARK: - Delete Item
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item);
                }
            } catch {
                print("Error saving item \(error)");
            }
            
        }
    }
    
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true);
        
        tableView.reloadData();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems();
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
}

