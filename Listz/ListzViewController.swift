//
//  ListzViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/11/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit

class ListzViewController: UITableViewController {

    var itemArray = ["Apples","Oranges","Bananas"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items = defaults.array(forKey: "ListzItemArray") as? [String] {
            itemArray = items
        }
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row), item \(itemArray[indexPath.row])")
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemPopup = UIAlertController(title: "Add New Listz Item", message: "", preferredStyle: .alert)
        
        let addItemPopupAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Item Added: \(textField.text ?? "")")
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ListzItemArray")
            self.tableView.reloadData()
        }
        
        let addItemPopupActionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Item Add Cancelled")
        }
        
        addItemPopup.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        addItemPopup.addAction(addItemPopupAction)
        addItemPopup.addAction(addItemPopupActionCancel)
        
        present(addItemPopup, animated: true, completion: nil)
        
    }
    
}

