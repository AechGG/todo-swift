//
//  CategoryViewController.swift
//  Todo
//
//  Created by Harrison Gittos on 24/08/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm();
    
    // Due to using Realm we no longer need to append to an Array as Realm using @objc dynamic variables
    // Meaning this will update whenever there is an update e.g. write to Realm
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadCategories();
        
        tableView.rowHeight = 100.0;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "1D9BF6");
        guard let navigationBar = navigationController?.navigationBar else { fatalError("No Navigation Bar Found")}
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(hexString: "1D9BF6");
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "1D9BF6");
        }
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row];
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        
        cell.backgroundColor = UIColor(hexString: category?.color ?? "1D9BF6");
        
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true);
        
        cell.textLabel?.text = category?.name ?? "No Items have been added" ;
        
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
            
            if let safeHexString = categories?[indexPath.row].color {
                guard let navigationBar = navigationController?.navigationBar else { fatalError("No Navigation Bar Found")}
                if #available(iOS 13.0, *) {
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithOpaqueBackground()
                    if let safeColor = UIColor(hexString: safeHexString) {
                        navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(safeColor, returnFlat: true)]
                        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(safeColor, returnFlat: true)]
                        navBarAppearance.backgroundColor = safeColor;
                    }
                    navigationBar.standardAppearance = navBarAppearance
                    navigationBar.scrollEdgeAppearance = navBarAppearance
                } else {
                    navigationController?.navigationBar.barTintColor = UIColor(hexString: safeHexString);
                }
            }
            
            
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
    
    // MARK: - Delete Category
    
    override func updateModel(at indexPath: IndexPath) {
        if let cat = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(cat);
                }
            } catch {
                print("Error deleting category \(error)");
            }
        }
    }
    
    // MARK: - Add Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            let newCategory = Category();
            newCategory.name = textField.text!;
            newCategory.color = UIColor.randomFlat().hexValue();
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
