//
//  ViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 16/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit

class ToDoMasterViewController: UITableViewController {
    
    var toDoArray = [String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoList") as? [String]{
            toDoArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myReuableCell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(toDoArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if         tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            self.toDoArray.append(tf.text!)
            
            self.defaults.set(self.toDoArray, forKey: "ToDoList")
            
            self.tableView.reloadData()   //Called when action is completed
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Items"
            tf = textField   //Called only when the UITextField is created
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
}

