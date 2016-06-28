//
//  SOPackage.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 1/31/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

import Foundation

class SOPackage : NSObject, NSCoding {

    var photo : UIImage = UIImage()
    // notification string and NSDate recorded
    var notifications : [Int:String] = [Int:String]()
    var reminders: [Int:Int] = [Int:Int]()
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(photo, forKey: "photo")
        aCoder.encodeObject(notifications, forKey: "notifications")
        aCoder.encodeObject(reminders, forKey: "reminders")
    }
    
    required convenience init(coder aDecoder:NSCoder) {
        self.init()
        self.photo = aDecoder.decodeObjectForKey("photo") as! UIImage
        self.notifications = aDecoder.decodeObjectForKey("notifications") as! [Int:String]
        self.reminders = aDecoder.decodeObjectForKey("reminders") as! [Int:Int]
    }
}