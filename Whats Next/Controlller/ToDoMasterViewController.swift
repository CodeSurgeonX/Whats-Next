//
//  ViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 16/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class ToDoMasterViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var toDoArray : Results<Item>?
    var realmDB = try! Realm()
    var selectedCategory : categoryItem? {
        didSet{
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title  = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {fatalError("No Freaking Nav Bar")}
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
              
                searchBar.barTintColor = navBarColor
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = super.tableView(tableView, cellForRowAt: indexPath)
        if let itemD = toDoArray?[indexPath.row]{
            cell.textLabel?.text = itemD.title
            cell.accessoryType = itemD.isDone ? .checkmark : .none
            
            
            if let parentColor = UIColor(hexString : (self.selectedCategory!.color))  {
                if let myColor =  parentColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoArray!.count)) {
                    cell.backgroundColor = myColor
                    cell.textLabel?.textColor = ContrastColorOf(myColor, returnFlat: true)
                }
            }
           
            
        } else{
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }



    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoArray?[indexPath.row]{
            do {
                try realmDB.write {
                    item.isDone = !item.isDone
//                    realmDB.delete(item)
                }
            }catch{
                print("There was an error changing status \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }




    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
          
//            tempItem.parentCategory = self.selectedCategory
           
            do{
                try self.realmDB.write {
                    if let c = tf.text?.count, c > 0 {
                        let tempItem = Item()
                        tempItem.title = tf.text!
                        tempItem.isDone = false
                        tempItem.dateCreated = Date()
                        self.selectedCategory?.items.append(tempItem)
                        self.realmDB.add(tempItem)
                    }
                }
            }catch{
                print("There was an error writing data \(error)")
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Items"
            tf = textField   //Called only when the UITextField is created
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }



    func loadData(){
            toDoArray = self.selectedCategory?.items.sorted(byKeyPath: "title", ascending: false) //Load but not from DB
            tableView.reloadData()
        }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoArray?[indexPath.row]{
            do{
                try realmDB.write {
                    realmDB.delete(item)
                }
            }catch{
                print("Error")
            }
        }
    }
    
    }

extension ToDoMasterViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoArray = toDoArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor =  UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = originalColor
    }

}
