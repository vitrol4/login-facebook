//
//  ProtectedPageViewController.swift
//  PhotoApp
//
//  Created by Victor Gomes on 16/09/15.
//  Copyright © 2015 Victor Gomes. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ProtectedPageViewController: ViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    
    var _userName: String!
    var _userEmail: String!
    var _url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let loginPageNav = UINavigationController(rootViewController: loginPage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPageNav
    }
    
    func returnUserData() {
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, first_name, last_name, email, picture.type(large)"])
            
            graphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
                if ((error) != nil) {
                    print("Error: \(error)")
                } else {
                    //                print("fetched user: \(result)")
                    
                    self._userName = result.valueForKey("name") as! String
                    print("User Name: \(self._userName)")
                    self._userEmail = result.valueForKey("email") as! String
                    print("User Email: \(self._userEmail)")
                    self._url = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! String
                    print("Photo URL: \(self._url)")
                    
                    self.name.text = self._userName
                    self.email.text = self._userEmail
                    
                    self.image.contentMode = UIViewContentMode.ScaleAspectFit
                    let checkedUrl = NSURL(string: self._url)!
                    self.downloadImage(checkedUrl)
                }
            })
        }
    }
    
    func getDataFromUrl(urL: NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func downloadImage(url: NSURL) {
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image.image = UIImage(data: data!)
            }
        }
    }
    
    
    
    
    
}
