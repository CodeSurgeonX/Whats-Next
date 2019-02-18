//
//  CategoryTableViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 17/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    var categoryArrray : Results<categoryItem>?
    
    let realmDB = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        load()
        self.tableView.rowHeight = 80.00
    }
    

    @IBAction func addButtonPressed(_ sender: Any) {
        var tf : UITextField = UITextField()
        let alert : UIAlertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        let action : UIAlertAction = UIAlertAction(title: "Add", style: .default) { (alertaction) in
            if let textMat = tf.text, textMat.count > 0 {
                let temp = categoryItem()
                temp.name = textMat
                self.save(temp)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter the new category"
            tf = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArrray?[indexPath.row].name ?? "No Categories Added"
        cell.accessoryType = .disclosureIndicator
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! ToDoMasterViewController
        let indexpath = tableView.indexPathForSelectedRow!
        let category : categoryItem = categoryArrray![indexpath.row]
        itemVC.selectedCategory = category
    }
}

extension CategoryTableViewController {

    
    func save(_ category : categoryItem){
        do {
            try realmDB.write {
                realmDB.add(category)
            }
        }catch {
            print("Error adding data \(error)")
        }
    }
    
    func load(){
        categoryArrray = realmDB.objects(categoryItem.self)
    }
    
}

extension CategoryTableViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let item = self.categoryArrray?[indexPath.row]{
                do{
                    
                    try self.realmDB.write {
                        self.realmDB.delete(item)
                    }
                }catch{
                    print(error)
                }
            }
//            self.tableView.reloadData() //Removed after adding the second optional method
        }
        
        // customize the action appearance
//        deleteAction.image = UIImage(named: "trash-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
    
}
