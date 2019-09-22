//
//  ViewController.swift
//  ToDoList
//
//  Created by atef on 9/21/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryVC: UIViewController  {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        loadItems()
    }
    
 
    
    @IBAction func addBtnPressedd(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Category ", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Category"
        }
        
        let action = UIAlertAction(title: "Add New Category", style: .default) { (_) in
            let category = Category(context: self.context)
            category.name = alert.textFields!.first!.text!
            category.completed = false
            self.categories.append(category)
            self.saveItem()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
 
    
    func saveItem() {
        do {
          try context.save()
          tableView.reloadData()
        }catch {
            print(error)
        }
      
    }
    
    
    func loadItems(predicate : NSPredicate? = nil) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let incomingPredicate = predicate {
            request.predicate = incomingPredicate
        }
        
        do {
            try categories = context.fetch(request)
            tableView.reloadData()
        }catch {
            print(error)
        }
    }
    
 
}



extension CategoryVC : UITableViewDelegate , UITableViewDataSource   {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            let category = categories[indexPath.row]
            cell.configureViews(category: category)
            cell.layer.cornerRadius = 3
            cell.delegate = self
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "toTasks", sender: selectedCategory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTasks" {
            guard let itemsVC = segue.destination as? ItemsVC else {return }
            itemsVC.selectedCategory = sender as? Category
            itemsVC.delegate = self
        }
       
        
    }
    
}




extension CategoryVC  : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            
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



extension CategoryVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadItems()
        }else {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            
            loadItems(predicate: predicate)
        }
    }
    
}


extension CategoryVC : completedTasks {
    
    func completeTask(numOfcompletedTasks: Int, selectedCategory: Category) {
        
        print("from function")
        print("base count")
        print(selectedCategory.items?.count ?? 1)
        print("our count")
        print(numOfcompletedTasks)
        
        if numOfcompletedTasks == selectedCategory.items?.count && numOfcompletedTasks > 0 {
            selectedCategory.completed = true
            saveItem()
        }else {
            selectedCategory.completed = false
            saveItem()
        }
    }
    
    
    
}


