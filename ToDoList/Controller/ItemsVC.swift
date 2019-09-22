//
//  TasksVC.swift
//  ToDoList
//
//  Created by atef on 9/21/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class ItemsVC: UIViewController   {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory : Category?
    var delegate : completedTasks?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    var completedItems : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadItems()
    }

    
    @IBAction func addBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Item"
        }
        
        let action = UIAlertAction(title: "Create Item", style: .default) { (_) in
            let item = Item(context: self.context)
            item.name = alert.textFields!.first!.text!
            item.done = false
            self.selectedCategory?.addToItems(item)
            self.items.append(item)
            self.saveItem()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        delegate?.completeTask(numOfcompletedTasks: completedItems, selectedCategory: selectedCategory!)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func saveItem() {
        do {
            try context.save()
            completedItems = 0
            tableView.reloadData()
        }catch {
            print(error)
        }
    }
    
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@" , selectedCategory!.name!)
        
        do {
            try items =  context.fetch(request)
            tableView.reloadData()
        }catch {
            print(error)
        }
        
    }
    
}

extension ItemsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as?   ItemCell {
            
            print(items[indexPath.row].done)
            
            if items[indexPath.row].done {
                cell.accessoryType = .checkmark
                completedItems = completedItems + 1
                print("from items table \(completedItems)")
            }else {
                cell.accessoryType = .none
            }
            
            let item = items[indexPath.row]
            
            cell.configureViews(item: item)
            cell.delegate = self
            return cell
        }else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        saveItem()
    }
    
}


extension ItemsVC : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            
            do {
                try self.context.save()
            }catch{
                print(error)
            }
            
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}




