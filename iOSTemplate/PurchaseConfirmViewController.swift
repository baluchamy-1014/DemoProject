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
  @IBOutlet var passPriceLabel: UILabel!
  @IBOutlet var codeValueLabel: UILabel!
  @IBOutlet var taxPriceLabel: UILabel!
  @IBOutlet var totalPriceLabel: UILabel!

  override func viewDidLoad() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PurchaseConfirmViewController.cancelPurchase))
    setupApplyButton()
    setupPromoTextField()
    super.viewDidLoad()
  }
  
  func setupApplyButton() {
    promoApplyButton.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor
    promoApplyButton.layer.borderWidth = 1.0
    promoApplyButton.layer.cornerRadius = 4.0
  }
  
  func setupPromoTextField() {
    promoTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor
    promoTextField.layer.borderWidth = 1.0
    self.promoTextField.addTarget(self, action: #selector(PurchaseConfirmViewController.textFieldDidChange(_:)), for: .editingChanged)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func cancelPurchase() {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }
  
  func textFieldDidChange(_ textField: UITextField) {
    promoApplyButton.isEnabled = true
  }

  @IBAction func useDidTapApplyButton(_ sender: Any) {
    
  }

}
