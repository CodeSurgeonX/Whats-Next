//
//  SwipeTableViewController.swift
//  Whats Next
//
//  Created by Shashwat  on 19/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.00
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell  
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
//
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at : indexPath)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath : IndexPath)  {
        //Updates the model
        print("Delete Model In Super")
    }


}

