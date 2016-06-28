//
//  AddNewNotificationViewController.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 2/1/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

import Foundation

class AddNewNotificationController : UIViewController {
    
    var so_pkg = SOPackage()
    var filePath = String()
    
    @IBOutlet weak var notification_text: UITextView!
    
    @IBOutlet weak var notification_date: UIDatePicker!
    @IBOutlet weak var reminder_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load data from state
        unarchive_pkg()
        
        // so the scroll view doesn't look janky
        self.automaticallyAdjustsScrollViewInsets = false
        
        }
    
    @IBAction func clear_textfield(sender: AnyObject) {
        self.notification_text.text = ""
        dismissKeyboard(sender)
    }
  
    @IBAction func save_data(sender: AnyObject) {
        
        let date_int = convert_date_to_int(notification_date.date)
        let remin_int = convert_date_to_int(reminder_date.date)
        if date_int < 0 {
            print("save unsuccessful :(")
        } else {
            so_pkg.notifications[date_int] = notification_text.text
            so_pkg.reminders[date_int] = remin_int
            archve_pkg()
            print("save successful!")

            save_success_alert()
            
            
            reset_views()
        }
    }
    
    func reset_views() {
        self.notification_text.text = ""
        self.notification_date.date = NSDate()
        self.reminder_date.date = NSDate()
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func unarchive_pkg() {
        // unpackage data into so_pkg object
        do {
            self.filePath = try FileSave.buildPath("sodata", inDirectory: NSSearchPathDirectory.CachesDirectory, subdirectory: "archive")
            if let tempso_pkg = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? SOPackage {
                self.so_pkg = tempso_pkg
            }
        } catch {
            print("failed unarchive")
        }
    }
    
    func archve_pkg() {
        //archive data from so_pkg object into file system
        do {
            self.filePath = try FileSave.buildPath("sodata", inDirectory: NSSearchPathDirectory.CachesDirectory, subdirectory: "archive")
            NSKeyedArchiver.archiveRootObject(self.so_pkg, toFile: self.filePath)
        } catch {
            print("failed archival, nothing saved")
        }
        
        
    }
    
    func convert_date_to_int(date: NSDate) -> Int {
        // get string value for date
        let f = NSDateFormatter()
        f.dateFormat = "YYYYMMddHHmm"
        let datestring = f.stringFromDate(date)
        
        // convert string to int
        if let date_int = Int(datestring) {
            print("successful conversion!")
            return date_int
        } else{
            print("problem in converting date to int, notification not saved")
            return -1
        }

    }
    
    func save_success_alert(){
        
        let alert = UIAlertController(title: "save complete", message: "Notification registered!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}