//
//  CategoryViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 24/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm();
    
    // Due to using Realm we no longer need to append to an Array as Realm using @objc dynamic variables
    // Meaning this will update whenever there is an update e.g. write to Realm
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadCategories();
        
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet";
        
        return cell;
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController;
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row];
        }
    }
    
    // MARK: - Data Manipulation
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category);
            };
        } catch {
            print("error saving data \(error)");
        }
        
        self.tableView.reloadData();
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self);
        tableView.reloadData();
    }
    
    // MARK: - Add Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            let newCategory = Category();
            newCategory.name = textField.text!;
            
            self.save(category: newCategory);
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
}
