//
//  ViewController.swift
//  TheBetterBoyfriend
//
//  Created by Christopher Katnic on 1/31/16.
//  Copyright © 2016 Christopher Katnic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var so_image_view: UIImageView!
    
    var so_pkg = SOPackage()
    var filePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //request_permissions()
        
        
        do {
            self.filePath = try FileSave.buildPath("sodata", inDirectory: NSSearchPathDirectory.CachesDirectory, subdirectory: "archive")
        } catch {
            print("unable to get filepath")
        }
        // unpackage
        if let tempso_pkg = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? SOPackage {
            print("unarchive successful, package loaded")
            self.so_pkg = tempso_pkg
        } else {
            print("unarchive unsuccessful")
            so_pkg.photo = UIImage()
        }
        
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":" id, significant_other"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else
                {
                    print("fetched user: \(result)")
                   
                    self.so_pkg.photo = self.returnUserProfileImage((result.valueForKey("significant_other")?.valueForKey("id"))! as! NSString)
                    
                    //archive data
                    do {
                        self.filePath = try FileSave.buildPath("sodata", inDirectory: NSSearchPathDirectory.CachesDirectory, subdirectory: "archive")
                    } catch {
                    }
                    NSKeyedArchiver.archiveRootObject(self.so_pkg, toFile: self.filePath)
                    
                    
                    self.so_image_view.image = self.so_pkg.photo
                    self.performSegueWithIdentifier("move_to_2", sender: self)
                }
            })
            
        }
        else
        {
            let loginView: FBSDKLoginButton = FBSDKLoginButton(frame: CGRect(x: 0, y: 460, width: 161, height: 33))
            self.view.addSubview(loginView)
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_relationships"]
            loginView.delegate = self
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var fbbutton: UIButton!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //stuff
        // pass the so_pkg to the next view controller
        
            if let dvc = segue.destinationViewController as? SOViewController{
            dvc.so_pkg = self.so_pkg
            print("transitioning to SOViewController")
        }
    }
    
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print("User Logged In")

        if ((error) != nil)
        {
            
            // Process error
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                
                // graphRequest gets current girlfriend's ID, in order to fetch pictures
                // in completion block
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":" id, significant_other"])
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
                    if ((error) != nil)
                    {
                        print("Error: \(error)")
                    }
                    else
                    {
                        print("fetched user: \(result)")
                        
                        let so_image: UIImage = self.returnUserProfileImage((result.valueForKey("significant_other")?.valueForKey("id"))! as! NSString)
                        
                        self.so_image_view.image = so_image
                        self.so_pkg.photo = so_image
                     
                        
                        // asynchronous dispatch to ensure package delivery to new view controller
                        dispatch_async(dispatch_get_main_queue(), {
                            [unowned self] in
                            self.performSegueWithIdentifier("move_to_2", sender: self)
                        })
                    }
                })
            }
            
        }
       
    }
    
    func returnUserProfileImage(accessToken: NSString) -> UIImage
    {
        let userID = accessToken as NSString
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            return UIImage(data: data)!
        }
        return UIImage()
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func request_permissions(){
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        }
    }

}

