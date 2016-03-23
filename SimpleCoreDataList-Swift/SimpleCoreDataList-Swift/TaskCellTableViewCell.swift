//
//  TaskCellTableViewCell.swift
//  SimpleCoreDataList-Swift
//
//  Created by Bronson Dupaix on 3/22/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    @IBOutlet weak var switchValue: UISwitch!

    @IBAction func taskCompleted(sender: UISwitch) {
        
        if switchValue.on {
    
        self.taskNameLabel.textColor = UIColor.cyanColor()
            self.createdDateLabel.textColor = UIColor.cyanColor()
            
           self.backgroundColor = UIColor.grayColor()
            
        } else {
            
            self.taskNameLabel.textColor = UIColor.blackColor()
            
            self.createdDateLabel.textColor = UIColor.blackColor()
            
            // self.backgroundColor = self.backgroundColor
        }
        
       //  if switchValue.
    }
}
