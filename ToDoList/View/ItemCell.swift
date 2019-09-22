//
//  ItemCell.swift
//  ToDoList
//
//  Created by atef on 9/22/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemCell: SwipeTableViewCell {

  
    
    @IBOutlet weak var itemTitleLbl: UILabel!
    
    
    func configureViews(item : Item){
        itemTitleLbl.text = item.name
    }
    
    
}
