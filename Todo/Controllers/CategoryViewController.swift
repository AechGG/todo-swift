//
//  CategoryViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 24/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]();
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadCategories();
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        
        cell.textLabel?.text = category.name;
        
        return cell;
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // MARK: - Data Manipulation
    
    func saveCategories() {
        do {
            try context.save();
        } catch {
            print("error saving data \(error)");
        }
        
        self.tableView.reloadData();
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request);
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData();
    }
    
    // MARK: - Add Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            let newCategory = Category(context: self.context);
            newCategory.name = textField.text!;
            
            self.categoryArray.append(newCategory);
            
            self.saveCategories();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
}
