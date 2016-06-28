//
//  FileDirectory.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 2/1/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

import Foundation

public struct FileDirectory {
    public static func applicationDirectory(directory:NSSearchPathDirectory) -> NSURL? {
        
        var appDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(directory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? String {
                appDirectory = pathString
            }
        }
        if let dD = appDirectory {
            return NSURL(string:dD)
        }
        return nil
    }
    
    public static func applicationTemporaryDirectory() -> NSURL? {
        
        let tD = NSTemporaryDirectory()
        
        return NSURL(string:tD)
        
    }
}