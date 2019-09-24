//
//  CategoryViewController.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/16/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    
    var catArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("File Manager Path: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
        loadCat()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else {fatalError("Fatal Error - Nav Controller does not exest")}
        let bgCol = UIColor(hexString: "1D9BF6")! //UIColor.flatGray()
        print("VWA")
        navBar.barTintColor = bgCol
        navBar.tintColor = ContrastColorOf(bgCol, returnFlat: true)

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(bgCol, returnFlat: true)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgCol, returnFlat: true)]
            navBarAppearance.backgroundColor = bgCol
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
        }

    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let addCatPopup = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let addCatPopupActionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Category added: \(textField.text ?? "")")
            let cat = Category()
            cat.name = textField.text ?? "Default"
            cat.cellColor = UIColor.randomFlat().hexValue()
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = catArray? [indexPath.row].name ?? "Create a category" //category.name
        cell.backgroundColor = UIColor(hexString: catArray?[indexPath.row].cellColor ?? UIColor.flatGray().hexValue() )
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: catArray?[indexPath.row].cellColor ?? UIColor.flatGray().hexValue() )!, returnFlat: true)
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let catForDeletion = self.catArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(catForDeletion.items)
                    self.realm.delete(catForDeletion)
                }
            } catch {
                print("Error deleting data: \(error)")
            }
            //tableView.reloadData()
        }
    }
}


//MARK: - SwipeCell Delegate methods
//extension CategoryViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            print("Delete action on \(self.catArray![indexPath.row].name)")
//
//            if let catForDeletion = self.catArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(catForDeletion)
//                    }
//                } catch {
//                    print("Error deleting data: \(error)")
//                }
//                //tableView.reloadData()
//            }
//
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "TrashIcon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//
//}
