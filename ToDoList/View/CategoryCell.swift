//
//  CategoryCell.swift
//  ToDoList
//
//  Created by atef on 9/21/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoryCell: SwipeTableViewCell {

  
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    
    
    
    func configureViews(category : Category) {
        categoryNameLbl.text = category.name
        
        if category.completed {
            completeView.isHidden = false
        }else {
            completeView.isHidden = true
        }
        
        
    }
    
}
