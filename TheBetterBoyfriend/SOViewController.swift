//
//  SOViewController.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 1/31/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

import Foundation

class SOViewController: UIViewController {

    var so_pkg = SOPackage()
    var filePath = String()
    @IBOutlet weak var SO_Image_View: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unpackage
        do {
            self.filePath = try FileSave.buildPath("sodata", inDirectory: NSSearchPathDirectory.CachesDirectory, subdirectory: "archive")
        } catch {
        }
        if let tempso_pkg = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? SOPackage {
            print("on some bullshit but unarchived")
            self.so_pkg = tempso_pkg
        }
        
        self.SO_Image_View.image = self.so_pkg.photo
        self.SO_Image_View.layer.cornerRadius = 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}