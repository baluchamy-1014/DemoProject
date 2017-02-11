//
//  UserController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 11/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class UserController: UIViewController {
  
  @IBOutlet weak var selectionView: UIView!
  @IBOutlet weak var formView: UIView!
  @IBOutlet weak var signInButton: UserScreenButton!
  @IBOutlet weak var signUpButton: UserScreenButton!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  let signInController: SignInController
  let signUpController: SignUpController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.signInButton.isSelected = true
    
    // hides line under navigation bar
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func switchToSignUpView(_ sender: AnyObject) {
    self.removeSubviews()
    signUpController.view.frame = CGRect(x: 0, y: 0, width: self.formView.bounds.size.width, height: self.formView.bounds.size.height)
    self.formView.addSubview(backgroundImageView)
    self.addBackgroundImageViewConstraints()
    self.formView.addSubview(signUpController.view)

    self.signInButton.isSelected = false
    self.signUpButton.isSelected = true
  }
  @IBAction func switchToSignInView(_ sender: AnyObject) {
    self.removeSubviews()
    self.formView.addSubview(backgroundImageView)
    self.addBackgroundImageViewConstraints()
    self.formView.addSubview(signInController.view)
    
    self.signInButton.isSelected = true
    self.signUpButton.isSelected = false
  }
  
  func addBackgroundImageViewConstraints() {
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: formView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: formView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: formView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: selectionView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
  }
  
  fileprivate func removeSubviews() {
    for view in self.formView.subviews {
      view.removeFromSuperview()
    }
  }
}
