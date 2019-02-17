//
//  CategoryTableViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 17/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArrray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error saving context data \(error)")
        }
    }
    
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArrray = try context.fetch(request)
        }catch{
            print("Error getting context data \(error)")
        }
        //Should fetch the results according to the category
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var tf : UITextField = UITextField()
        let alert : UIAlertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        let action : UIAlertAction = UIAlertAction(title: "Add", style: .default) { (alertaction) in
            if let textMat = tf.text, textMat.count > 0 {     //for i in 1...5 where i%2==0
            let categoryItem : Category = Category(context: self.context)
            categoryItem.categoryTitle = textMat
            self.categoryArrray.append(categoryItem)
            self.saveData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArrray[indexPath.row].categoryTitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! ToDoMasterViewController
        let indexpath = tableView.indexPathForSelectedRow!
        let category : Category = categoryArrray[indexpath.row]
        itemVC.selectedCategory = category
    }
}
