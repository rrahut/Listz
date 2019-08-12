//
//  ListzViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/11/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit

class ListzViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Apples"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Oranges"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Bananas"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ListzItemArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row \(indexPath.row), item \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemPopup = UIAlertController(title: "Add New Listz Item", message: "", preferredStyle: .alert)
        
        let addItemPopupAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Item Added: \(textField.text ?? "")")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ListzItemArray")
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

