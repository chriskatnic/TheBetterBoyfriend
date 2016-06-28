//
//  ReminderViewController.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 2/2/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

// TODO: delete old
// TODO: garbage collection on old notes


import Foundation

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var ReminderTextView: UITextView!
    
    var so_pkg = SOPackage()
    var filePath = String()
    override func viewDidLoad() {
        
        // unarchive current package
        unarchive_pkg()
        
        // extract the notification dictionary and sort it
        // save to sorted_ntoes object
        let sorted_notes = get_sorted_notes(so_pkg.notifications)
        
        // format the sorted notes into a [String:String] dictionary
        // to more easily convert into attributed string
        let formatted_sorted_notes = format_note_dates(sorted_notes)
        
        // convert dictionary into attributed string
        // and place inside the reminder text view
        let nsas : NSAttributedString = create_attributed_string(formatted_sorted_notes)
        let nsas2 : NSMutableAttributedString = NSMutableAttributedString(attributedString: nsas)
        
        
        nsas2.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica Neue", size: (CGFloat.init(integerLiteral: 15)))!, range: NSRange.init(location: 0, length: nsas2.length))
        
        
        self.ReminderTextView.attributedText = nsas2
        
        
    }
    
    
    // create the attributed string to replace what's in the reminder
    // text view
    func create_attributed_string(notes: [String:String]) -> NSAttributedString {
        var temp: String = String()
        for (k, v) in notes{
            let s = " - \(k)\n\(v)\n\n"
            temp.appendContentsOf(s)
            
        }
        
        return NSAttributedString(string: temp)
    }
    
    func format_note_dates(notes: [Int:String]) -> [String:String]{
    
        var formatted = [String:String]()

        // at the end, it will be converted into a readable string
        for (k, v) in notes {
            //201602032459
            let m_int = k % 100 // takes first two digits
            let h_int = (k % 10000) / 100 // takes second two digits
            let d_int = (k % 1000000) / 10000 // third two...
            let mo_int = (k % 100000000) / 1000000 // fourth..
            let y_int = (k % 10000000000) / 100000000 // last 4 digits
            
            let date_string = "\(d_int)-\(mo_int)-\(y_int) \(h_int):\(m_int)"
            
            formatted[date_string] = v
        }

        return formatted
    }
    
    func get_sorted_notes(notes: [Int:String]) -> [Int:String] {
        
        let sorted_notes = notes.sort{ $0.0 < $1.0 }
        var sorted: [Int:String] = [Int:String]()
        
        print("successfully sorted..\n\(sorted_notes)")
        
        for (k, v) in sorted_notes {
            sorted[k] = v
        }
        return sorted
        
    }
    
    
    // template functions from previous view controllers
    
    @IBAction func save_data(sender: AnyObject) {
        
        
        // TODO: change following two values NSDate() and NSDate() into appropriate values
        let date_int = convert_date_to_int(NSDate())
        let remin_int = convert_date_to_int(NSDate())
        if date_int < 0 {
            print("save unsuccessful :(")
        } else {
            // TODO: assign appropriate value "blahblahblah" to a more appropriate value
            so_pkg.notifications[date_int] = "blahblahblah"
            so_pkg.reminders[date_int] = remin_int
            archve_pkg()
            print("save successful!")
        }
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
    
}