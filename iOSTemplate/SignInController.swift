//
//  SignInController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class SignInController: UIViewController {

  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var alertViewController: UIAlertController?
  var alertAction: UIAlertAction?
  var containerController: UserController?

  @IBOutlet weak var usernameField: SignInUpTextField!
  @IBOutlet weak var passwordField: SignInUpTextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var invalidLabel: UILabel!
  @IBOutlet weak var signInButton: SignInUpButton!
  
  
  override func viewDidLoad() {
    self.alertViewController = UIAlertController.init(title: "Login Successful!", message: "You will now be redirected to home screen", preferredStyle: UIAlertControllerStyle.alert)
    
    self.alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
      self.alertViewController?.dismiss(animated: true, completion: nil)
    })
    self.alertViewController!.addAction(self.alertAction!)
    self.activityIndicator.isHidden = true
    
    self.signInButton.isEnabled = false
  
    NotificationCenter.default.addObserver(self,
                                                     selector: #selector(SignInController.textFieldDidChange(_:)),
                                                     name: NSNotification.Name.UITextFieldTextDidChange,
                                                     object: nil)

    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    usernameField.createBottomBorder()
    passwordField.createBottomBorder()
  }
  
  func textFieldDidChange(_ sender: AnyObject){
    if EmailValidator().isValidEmail(self.usernameField.text!) && passwordLengthMet() {
      self.signInButton.isEnabled = true
    }
    else {
      self.signInButton.isEnabled = false
    }
  }
  
  @IBAction func signInTapped(_ sender: AnyObject) {
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
    Session.shared().authenticate(self.usernameField.text!, password: self.passwordField.text!) { (session, error) in
      if ((session) != nil) {
        self.invalidLabel.text = ""
        if ((session as? Session)?.isValid())! {
          if let _ = self.containerController?.sessionDelegate {
            self.containerController?.popSelfFromNavigationController()
          } else {
            self.containerController!.present(self.alertViewController!, animated: true, completion: nil)
            self.containerController?.sessionDelegate?.userDidSignIn()
          }
          self.appDelegate.keymakerOrganizer.saveKeymakerToken(Session.shared().accessToken)
        } else {
          self.invalidLabel.text = "The username or password is incorrect."
        }
      } else {
        self.invalidLabel.text = "An error occurred."
      }
      self.activityIndicator.stopAnimating()
      self.activityIndicator.isHidden = true
    }
  }
  
  fileprivate func passwordLengthMet() -> Bool {
    return (self.passwordField.text?.characters.count >= 8)
  }

}
