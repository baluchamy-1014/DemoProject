//
//  SignUpController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit



class SignUpController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmationTextField: UITextField!
  
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var signUpButton: UIButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var successViewController: SignUpSuccessViewController?
  
  var successView: UIView?
  
  override func viewDidLoad() {
    self.activityIndicator.hidden = true
    self.signUpButton.layer.cornerRadius = 5.0
    super.viewDidLoad()
  }

  override func viewWillDisappear(animated: Bool) {
    clearErrorLabels()
  }
  
  @IBAction func signUpTapped(sender: AnyObject) {
    clearErrorLabels()
    if isValidEmail(self.emailTextField.text!) {
      if (passwordsMatch()) {
        if passwordLengthMet() {
          let resourceOwner: NSDictionary = [
            "resource_owner":["email_address": self.emailTextField.text!],
            "credential":["password": self.passwordTextField.text!, "password_confirmation":self.passwordConfirmationTextField.text!]
          ]
          self.activityIndicator.hidden = false
          self.activityIndicator.startAnimating()
          SRUser.create(resourceOwner as [NSObject : AnyObject]) { (response, error) in
            if (error == nil) {
              if let _ = response as? SRUser {
                if (Session.sharedSession().isValid()) {
                  self.clearTextFields()
                  self.successViewController = SignUpSuccessViewController(nibName: "SignUpSuccess", bundle: nil)
                  self.presentViewController(self.successViewController!, animated: true, completion: nil)
                }
              }
            } else {
              if response["error"] as? String == "conflicting_resource_owner" {
                self.emailErrorLabel.text = "Email has already been used"
              } else if response["error"] as? String == "invalid_request" {
                self.emailErrorLabel.text = "Email is invalid"
              } else {
                self.emailErrorLabel.text = response["error_description"] as? String
              }
              print("error is \(error) and response is \(response)")
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
          }
        } else {
          self.passwordErrorLabel.text = "Password should be at least 8 characters"
        }
      } else {
        self.passwordErrorLabel.text = "Password do not match"
      }
    } else {
      self.emailErrorLabel.text = "Email is invalid"
    }

  }

  private func passwordsMatch() -> Bool {
    return (self.passwordTextField.text == self.passwordConfirmationTextField.text)
  }
  
  private func passwordLengthMet() -> Bool {
    return (self.passwordTextField.text?.characters.count >= 8)
  }
  
  private func clearErrorLabels() {
    self.emailErrorLabel.text = ""
    self.passwordErrorLabel.text = ""
  }
  
  private func clearTextFields() {
    self.passwordTextField.text = ""
    self.passwordConfirmationTextField.text = ""
  }
  
  func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
  }
}


class SignUpSuccessViewController: UIViewController {
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  @IBOutlet weak var letsGoButton: UIButton!
  
  override func viewDidLoad() {
    self.letsGoButton.layer.cornerRadius = 5.0
  }
  
  @IBAction func letsGoTapped(sender: AnyObject) {
    self.appDelegate.viewController!.selectedIndex = 0
    self.dismissViewControllerAnimated(false) {
    }
  }

}