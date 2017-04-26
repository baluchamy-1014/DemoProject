//
//  SignUpController.swift
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




class SignUpController: UIViewController {
  
  @IBOutlet weak var emailTextField: SignInUpTextField!
  @IBOutlet weak var passwordTextField: SignInUpTextField!
  @IBOutlet weak var passwordConfirmationTextField: SignInUpTextField!
  
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var passwordCharErrorLabel: UILabel!
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var signUpButton: SignInUpButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var successViewController: SignUpSuccessViewController?
  
  var successView: UIView?
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var containerController: UserController?

  override func viewDidLoad() {
    self.activityIndicator.isHidden = true
    self.signUpButton.isEnabled = false
    
    self.emailTextField.addTarget(self, action: #selector(SignUpController.textFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
    self.passwordTextField.addTarget(self, action: #selector(SignUpController.textFieldDidChange(_:)), for: .editingChanged)
    self.passwordConfirmationTextField.addTarget(self, action: #selector(SignUpController.textFieldDidChange(_:)), for: .editingChanged)
    
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    emailTextField.createBottomBorder()
    passwordTextField.createBottomBorder()
    passwordConfirmationTextField.createBottomBorder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    clearErrorLabels()
  }
  
  func textFieldDidChange(_ textField: UITextField){
    if EmailValidator().isValidEmail(self.emailTextField.text!) && passwordLengthMet() && (passwordsMatch())
    {
      self.signUpButton.isEnabled = true
    }
    else {
      self.signUpButton.isEnabled = false
      switch textField.tag {
      case 0:
        if !EmailValidator().isValidEmail(self.emailTextField.text!) {
          self.emailErrorLabel.text = "Email is invalid"
        }
        else {
          self.emailErrorLabel.text = ""
        }
      case 1:
        if !passwordLengthMet() {
          self.passwordCharErrorLabel.text = "Password should be at least 8 characters"
        }
        else {
          self.passwordCharErrorLabel.text = ""
        }        
      case 2:
        if !passwordsMatch() {
          self.passwordErrorLabel.text = "Password don't match"
        }
        else {
          self.passwordErrorLabel.text = ""
        }
      default:
        break
      }
    }
  }
  
  @IBAction func signUpTapped(_ sender: AnyObject) {
    clearErrorLabels()
    if EmailValidator().isValidEmail(self.emailTextField.text!) {
      if (passwordsMatch()) {
        if passwordLengthMet() {
          let resourceOwner: NSDictionary = [
            "resource_owner":["email_address": self.emailTextField.text!],
            "credential":["password": self.passwordTextField.text!, "password_confirmation":self.passwordConfirmationTextField.text!]
          ]
          self.activityIndicator.isHidden = false
          self.activityIndicator.startAnimating()
          SRUser.create(resourceOwner as! [AnyHashable: Any]) { (response, error) in
            if (error == nil) {
              if let _ = response as? SRUser {
                if (Session.shared().isValid()) {
                  self.appDelegate.keymakerOrganizer.saveKeymakerToken(Session.shared().accessToken)
                  self.clearTextFields()
                  self.successViewController = SignUpSuccessViewController(nibName: "SignUpSuccess", bundle: nil)
                  self.successViewController?.containerController = self.containerController
                  self.present(self.successViewController!, animated: true, completion: nil)
                }
              }
            } else {
              if let response = response as? [String: AnyObject] {
                if response["error"] as? String == "conflicting_resource_owner" {
                  self.emailErrorLabel.text = "Email has already been used"
                } else if response["error"] as? String == "invalid_request" {
                  self.emailErrorLabel.text = "Email is invalid"
                } else {
                  self.emailErrorLabel.text = response["error_description"] as? String
                }
                print("error is \(error) and response is \(response)")
              }
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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

  fileprivate func passwordsMatch() -> Bool {
    return (self.passwordTextField.text == self.passwordConfirmationTextField.text)
  }
  
  fileprivate func passwordLengthMet() -> Bool {
    return (self.passwordTextField.text?.characters.count >= 8)
  }
  
  fileprivate func clearErrorLabels() {
    self.emailErrorLabel.text = ""
    self.passwordCharErrorLabel.text = ""
    self.passwordErrorLabel.text = ""
  }
  
  fileprivate func clearTextFields() {
    self.passwordTextField.text = ""
    self.passwordConfirmationTextField.text = ""
  }
  
}


class SignUpSuccessViewController: UIViewController {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  @IBOutlet weak var letsGoButton: UIButton!
  var containerController: UserController?

  override func viewDidLoad() {
    self.letsGoButton.layer.cornerRadius = 5.0
  }
  
  @IBAction func letsGoTapped(_ sender: AnyObject) {
    if ((self.containerController?.sessionDelegate) != nil) {
      self.containerController?.popSelfFromNavigationController()
    } else {
      appDelegate.sendUserToHomeScreen()
    }

    self.dismiss(animated: false) {
    }
  }

}
