//
//  UserController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

@objc protocol UserSessionDelegate {
  func userDidSignIn()
  @objc optional func userDidSignOut()
}

class UserController: UIViewController {
  
  @IBOutlet weak var selectionView: UIView!
  @IBOutlet weak var formView: UIView!
  @IBOutlet weak var signInButton: UserScreenButton!
  @IBOutlet weak var signUpButton: UserScreenButton!
  
  let signInController: SignInController
  let signUpController: SignUpController
  var sessionDelegate: UserSessionDelegate?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.signInController = SignInController(nibName: "SignIn", bundle: nil)
    self.signUpController = SignUpController(nibName: "SignUp", bundle: nil)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.signInController.containerController = self
    self.signUpController.containerController = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    self.formView.addSubview(signInController.view)
    self.title = "Welcome To NLL TV!"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.signInButton.isSelected = true
    
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // hides line under navigation bar
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = nil
    self.navigationController?.navigationBar.isTranslucent = false
  }

  @IBAction func switchToSignUpView(_ sender: AnyObject) {
    self.removeSubviews()
    signUpController.view.frame = CGRect(x: 0, y: 0, width: self.formView.bounds.size.width, height: self.formView.bounds.size.height)
    self.formView.addSubview(signUpController.view)

    self.signInButton.isSelected = false
    self.signUpButton.isSelected = true
  }
  @IBAction func switchToSignInView(_ sender: AnyObject) {
    self.removeSubviews()
    self.formView.addSubview(signInController.view)
    
    self.signInButton.isSelected = true
    self.signUpButton.isSelected = false
  }

  func popSelfFromNavigationController() {
    _ = self.navigationController?.popViewController(animated: true)
    self.signUpController.view.isHidden = true
    self.sessionDelegate?.userDidSignIn()
  }

  fileprivate func removeSubviews() {
    for view in self.formView.subviews {
      view.removeFromSuperview()
    }
  }
}
