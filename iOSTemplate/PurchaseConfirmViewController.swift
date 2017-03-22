//
//  PurchaseConfirmViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/7/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class PurchaseConfirmViewController: UIViewController {
  @IBOutlet var bodyView: UIView!
  @IBOutlet var passTitle: UILabel!
  @IBOutlet var passSubtitle: UILabel!
  @IBOutlet var promoApplyButton: UIButton!
  @IBOutlet var promoTextField: UITextField!
  
  override func viewDidLoad() {
    promoApplyButton.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor
    promoApplyButton.layer.borderWidth = 1.0
    promoApplyButton.layer.cornerRadius = 4.0
    
    promoTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor
    promoTextField.layer.borderWidth = 1.0
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PurchaseConfirmViewController.cancelPurchase))

    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func cancelPurchase() {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }

}
