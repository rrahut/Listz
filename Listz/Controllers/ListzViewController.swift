//
//  ListzViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/11/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListzViewController: SwipeTableViewController {

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
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate = self
        //loadItems()
        //tableView.
        tableView.separatorStyle = .none

 
    }

    override func viewWillAppear(_ animated: Bool) {
        if let colorHEX = selectedCategory?.cellColor {
            guard let navBar = navigationController?.navigationBar else {fatalError("Fatal Error - Nav Controller does not exest")}

            navBar.barTintColor = UIColor(hexString: colorHEX)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colorHEX)!, returnFlat: true)
            
            title = selectedCategory!.name
            searchBar.barTintColor = UIColor(hexString: colorHEX)
            
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(UIColor(hexString: colorHEX)!, returnFlat: true)]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(UIColor(hexString: colorHEX)!, returnFlat: true)]
                navBarAppearance.backgroundColor = UIColor(hexString: colorHEX)
                navBar.standardAppearance = navBarAppearance
                navBar.scrollEdgeAppearance = navBarAppearance
            }
            
         }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        guard let oc = UIColor(hexString: "1D9BF6") else {fatalError("Error in VWD")}
//        let navBar = navigationController!.navigationBar
//        
//        navBar.barTintColor = oc
//        navBar.tintColor = ContrastColorOf(oc, returnFlat: true)
//        
//        if #available(iOS 13.0, *) {
//            let navBarAppearance = UINavigationBarAppearance()
//            navBarAppearance.configureWithOpaqueBackground()
//            navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(oc, returnFlat: true)]
//            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(oc, returnFlat: true)]
//            navBarAppearance.backgroundColor = oc
//            navBar.standardAppearance = navBarAppearance
//            navBar.scrollEdgeAppearance = navBarAppearance
//        }
//    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray? .count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat( itemArray!.count ) ) {
                
//            }
//
//            if let color = FlatWhite().darken(byPercentage: CGFloat(indexPath.row) / CGFloat( itemArray!.count ) ) {
                cell.backgroundColor = color //selectedCategory?.cellColor
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
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

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.itemArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting data: \(error)")
            }
        }
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
