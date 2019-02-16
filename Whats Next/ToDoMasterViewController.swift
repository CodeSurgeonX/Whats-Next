//
//  ViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 16/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit

class ToDoMasterViewController: UITableViewController {
    
    var toDoArray = [ItemModel]()
//    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let items = defaults.array(forKey: "ToDoList") as? [ItemModel]{
//            toDoArray = items
//        }
        
//        var item = ItemModel()
//        item.isDone = true
//        item.title = "First Task"
//        toDoArray.append(item)
//
//        item = ItemModel()
//        item.isDone = false
//        item.title = "Second Task"
//        toDoArray.append(item)
//
//        item = ItemModel()
//        item.isDone = false
//        item.title = "Third Task"
//        toDoArray.append(item)
//        print(filePath!)
        //Check if the data you are getting isn't nil
        loadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myReuableCell", for: indexPath)
        cell.textLabel?.text = (toDoArray[indexPath.row] as ItemModel).title
        
        let item = toDoArray[indexPath.row]
        cell.accessoryType = item.isDone ? .checkmark : .none
        //Dont use that table view method of cellforrowat, keep in mind cell is stillbeing created
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoArray[indexPath.row].isDone = !toDoArray[indexPath.row].isDone
        saveData()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        //REMOVED CODE THAT USED TO SET ACCESSORY TYPE HERE
    }
    
    
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let tempModel = ItemModel()
            tempModel.title = tf.text!
            tempModel.isDone = false
            self.toDoArray.append(tempModel)
            self.saveData()
//            self.defaults.set(self.toDoArray, forKey: "ToDoList")
            
            self.tableView.reloadData()   //Called when action is completed
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Items"
            tf = textField   //Called only when the UITextField is created
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveData(){
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.toDoArray)
            try data.write(to: self.filePath!)
        } catch{
            print("Error")
        }
    }
    
    func loadData(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: filePath!){
            do{
               toDoArray =  try decoder.decode([ItemModel].self, from: data)
            }catch{
                print("Error in decoding the data \(error)")
            }
        }
    }
    
}

