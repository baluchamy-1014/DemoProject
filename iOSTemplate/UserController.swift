//
//  UserController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class UserController: UIViewController {
  
  @IBOutlet weak var formView: UIView!
  @IBOutlet weak var signInButton: UserScreenButton!
  @IBOutlet weak var signUpButton: UserScreenButton!
  
  let signInController: SignInController
  let signUpController: SignUpController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    self.signInController = SignInController(nibName: "SignIn", bundle: nil)
    self.signUpController = SignUpController(nibName: "SignUp", bundle: nil)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.signInController.containerController = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    self.formView.addSubview(signInController.view)
    self.title = "Welcome To NLL TV!"
    self.signInButton.selected = true
    
    // hides line under navigation bar
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.popViewControllerAnimated(true)
  }

  @IBAction func switchToSignUpView(sender: AnyObject) {
    self.removeSubviews()
    signUpController.view.frame = CGRectMake(0, 0, self.formView.bounds.size.width, self.formView.bounds.size.height)
    self.formView.addSubview(signUpController.view)
    self.signInButton.selected = false
    self.signUpButton.selected = true
  }
  @IBAction func switchToSignInView(sender: AnyObject) {
    self.removeSubviews()
    self.formView.addSubview(signInController.view)
    self.signInButton.selected = true
    self.signUpButton.selected = false
  }
  
  private func removeSubviews() {
    for view in self.formView.subviews {
      view.removeFromSuperview()
    }
  }
}