//
//  SignInController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var alertViewController: UIAlertController?
  var alertAction: UIAlertAction?
  var containerController: UIViewController?
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var invalidLabel: UILabel!
  @IBOutlet weak var signInButton: SignInUpButton!
  
  
  override func viewDidLoad() {
    self.alertViewController = UIAlertController.init(title: "Login Successful!", message: "You will now be redirected to home screen", preferredStyle: UIAlertControllerStyle.Alert)
    
    self.alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
      self.alertViewController?.dismissViewControllerAnimated(true, completion: nil)
      self.appDelegate.viewController!.selectedIndex = 0
    })
    self.alertViewController!.addAction(self.alertAction!)
    self.activityIndicator.hidden = true

    super.viewDidLoad()
  }
  

  
  @IBAction func signInTapped(sender: AnyObject) {
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    Session.sharedSession().authenticate(self.usernameField.text!, password: self.passwordField.text!) { (session, error) in
      if ((session) != nil) {
        self.invalidLabel.text = ""
        if (session.isValid()) {
          self.containerController!.presentViewController(self.alertViewController!, animated: true, completion: nil)
        } else {
          self.invalidLabel.text = "The username or password is incorrect."
        }
      } else {
        self.invalidLabel.text = "An error occurred."
      }
      self.activityIndicator.stopAnimating()
      self.activityIndicator.hidden = true
    }
  }

}