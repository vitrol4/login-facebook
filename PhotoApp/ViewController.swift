//
//  ViewController.swift
//  PhotoApp
//
//  Created by Victor Gomes on 15/09/15.
//  Copyright (c) 2015 Victor Gomes. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    var userName: String!
    var userEmail: String!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        } else {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            callAnotherScreen()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            print(error.localizedDescription)
            return
        }
        
        if (result.token != nil) {
            //Get user access token
            let token:FBSDKAccessToken = result.token
            print("Token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("User ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            callAnotherScreen()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user is logged out")
    }
    
    func callAnotherScreen() {
        let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
        let protectedPageNav = UINavigationController(rootViewController: protectedPage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = protectedPageNav
    }

}

