//
//  ListzViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/11/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit
import RealmSwift

class ListzViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate = self
        loadItems()
        //tableView.
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray? .count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemPopup = UIAlertController(title: "Add New Listz Item", message: "", preferredStyle: .alert)
        
        let addItemPopupAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Item Added: \(textField.text ?? "")")
            
            if let cat = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        cat.items.append(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
            }
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
    
    //MARK: - Model manipulation Methods
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

//MARK: - Search Bar Methods
extension ListzViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        print(searchBar.text!)
        //itemArray = selectedCategory?.items.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        //loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
