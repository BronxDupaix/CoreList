//
//  TasksTableViewController.swift
//  SimpleCoreDataList-Swift
//
//  Created by Bronson Dupaix on 3/22/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    var tasksArray = [NSManagedObject]()
    
    var nameString: String = ""
    
    var moc = DataController().managedObjectContext
    
    var today = NSDate()
    
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchTasks()

    }
    
    // MARK: - Add Task Button
    
    
    @IBAction func addTaskButton(sender: AnyObject) {
        
        print("AddTaskTapped")
        //Step-1 create a UIAlertController
        let alertController = UIAlertController(title: "Add", message: "Please add a task name", preferredStyle: .Alert)
        
        //Step-2 create action for alert controller/ Save and Cancel
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (alertAction) -> Void in
            
            print("SavePressed")
            
              // Step-5 add textfield
            
            if let textField = alertController.textFields?.first,
                let name = textField.text {
                    
                    let createdDate = NSDate()
                    
                    self.dateFormatter.dateFormat = "MM-dd-yy HH:mm:ss"
                    
                    let created = self.dateFormatter.stringFromDate(createdDate)

                    self.saveTask(name, created: createdDate)
                    
                    print(created)  
                    
                    self.tableView.reloadData()
                    
                   //  print("Name:\(self.nameString)")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alertAction) -> Void in
            
            print("CancelledPressed")
        }
        
        //Step-6 add text field to alert controller
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
         
        }
        
        //Step-3 add actions to alert controller
        alertController.addAction(saveAction)
        
        alertController.addAction(cancelAction)
        
        //Step-4 present the action view controller over the top of the current view controller
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return self.tasksArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as? TaskCellTableViewCell
        
        
        let task = self.tasksArray[indexPath.row] 
        
        self.dateFormatter.dateFormat = "MM-dd-yy HH:mm:ss"
        
        let todaysDate = dateFormatter.stringFromDate(today)
        
        if let name = task.valueForKey("name") as? String {
 
        cell?.taskNameLabel?.text = name
            
        }
        
        if let date = task.valueForKey("created") as? NSDate {
            
            self.dateFormatter.dateFormat = "MM-dd HH:mm"
            
            let createdDate = dateFormatter.stringFromDate(date)
            
            cell?.createdDateLabel.text = (createdDate) 
            
            let createdTimeStamp = date.timeIntervalSince1970
            
            let currentTimeStamp = NSDate().timeIntervalSince1970
            
//            print(createdTimeStamp)
//            
//            print("CurrentTimeStamp\(currentTimeStamp)")
//            
//           print(createdTimeStamp - currentTimeStamp)
            
            if createdTimeStamp - currentTimeStamp > -850 {
                
                cell?.backgroundColor = UIColor.greenColor()
                
            } else {
                
                if createdTimeStamp - currentTimeStamp > -1200 {
                
                cell?.backgroundColor = UIColor.orangeColor()
                    
                } else {
                    
                    if createdTimeStamp - currentTimeStamp > -1600 {
                    cell?.backgroundColor = UIColor.redColor()
                        
                    }
                }
            }
            
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let task = self.tasksArray[indexPath.row]
        
        if let completed = task.valueForKey("isCompleted") as? Bool {
            
            print(completed)
            
        } else {
            
            print("No boolean value")
        }
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            self.moc.deleteObject(tasksArray[indexPath.row])
            
            tasksArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
            
            do {
            
                try self.moc.save()
                print("managed object deleted and new array saved")
                
            }catch {
                
                print("Couldnt delete managed object")
            }
            
            
        }
    }

        //MARK: - Utility Methods
    
    func showAlert(title: String, message: String){
        
        print("AddTaskTapped")
        //Step-1 create a UIAlertController
        let alertController = UIAlertController(title: title, message: message,preferredStyle: .Alert)
        
        //Step-2 create action for alert controller/ Save and Cancel
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) -> Void in
            
            print("OKPressed")
            
            
        }
        
        //Step-3 add actions to alert controller
        
        alertController.addAction(okAction)

        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func saveTask(name: String, created: NSDate) {
        
        // Step-1 Create Entity with type desired
        
        if let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.moc) {
        
        // Step -2 create an NSManaged object out of our entity
            
            // Step - 3 create a var from our DataController / moc
        let task = NSManagedObject(entity: taskEntity, insertIntoManagedObjectContext: self.moc)
            
            task.setValue(name, forKey:"name")
            
            task.setValue(created, forKey: "created")
            
            // Step-4  save our object
        
            do {
                
                try self.moc.save()
                
                print("Saved Task")
                
                // Step-5 append task to array
                
                self.tasksArray.append(task)
            
                
            } catch {
                
                print(" Error couldnt save task")
            }
        
        }
        
        
    }
    
    func fetchTasks() {
        
        //Step-1  Create fetch request
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        //Step-2 decide how to sort fetched objects
        
        let sortDescriptor = NSSortDescriptor(key: "name" , ascending: true)
        
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            if let results = try self.moc.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                
                self.tasksArray = results
                
                self.tableView.reloadData()
                
                print("Tasks have been fetched")
                
            }
            
        }catch {
            
            print("Error couldnt fetch items")
        }
        
    }
    
    
    
}
