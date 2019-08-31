//
//  CategoryViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/16/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    
    var catArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("File Manager Path: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        loadCat()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let addCatPopup = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let addCatPopupActionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Category added: \(textField.text ?? "")")
            let cat = Category()
            cat.name = textField.text ?? "Default"
            //self.catArray.append(cat)
            self.save(category: cat)
        }
        
        let addCatPopupActionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Add category operation canceled")
        }
        
        addCatPopup.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category"
            textField = alertTextField
        }
        
        addCatPopup.addAction(addCatPopupActionAdd)
        addCatPopup.addAction(addCatPopupActionCancel)
        
        present(addCatPopup,animated: true,completion: nil)
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ListzViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = catArray?[indexPath.row]
            }
        }
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray? .count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //let category = catArray[indexPath.row]
        cell.textLabel?.text = catArray? [indexPath.row].name ?? "Create a category" //category.name
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCat() {
        catArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories: \(error)")
        }
        tableView.reloadData()
    }
}
