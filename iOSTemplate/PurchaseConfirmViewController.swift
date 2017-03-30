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
  @IBOutlet var passTypeLabel: UILabel!
  @IBOutlet var passPriceLabel: UILabel!
  @IBOutlet var codeValueLabel: UILabel!
  @IBOutlet var taxPriceLabel: UILabel!
  @IBOutlet var totalPriceLabel: UILabel!
  @IBOutlet var promoCodeErrorLabel: UILabel!
  var product: Product!
  var offer: Offer!
  
  init(product aProduct: Product, anOffer: Offer) {
    super.init(nibName:nil, bundle:nil)
    product = aProduct
    offer = anOffer
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PurchaseConfirmViewController.cancelPurchase))
    setupApplyButton()
    setupPromoTextField()
    setLabelValues()
    super.viewDidLoad()
  }
  
  func setLabelValues() {
    let numberFormatter = NumberFormatter()
    let locale = NSLocale(localeIdentifier: offer.currency)
    let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
    passTitle.text = product.name
    passTypeLabel.text = product.category
    passPriceLabel.text = "\(currencySymbol!) \(offer.price!)"
    // TODO: replace with calculated value from dealer
    taxPriceLabel.text = "$  3.32"
    // TODO: replace promoValue with one from dealer
    totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: numberFormatter.number(from: offer.price) as! CGFloat, promoValue: 0))"
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
  
  func calculateSum(orginalPrice: CGFloat, promoValue: CGFloat) -> String {
    // TODO: centralize local/currency
    let locale = NSLocale(localeIdentifier: offer.currency)
    let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
    let taxNum = (orginalPrice - promoValue) * CGFloat(0.095)
  // TODO: find out where tax comes from and replace
    taxPriceLabel.text = "\(currencySymbol!) \(String(format: "%.2f", taxNum))"
    return String(format: "%.2f", ((orginalPrice - promoValue) + taxNum))
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
    let numberFormatter = NumberFormatter()
    let locale = NSLocale(localeIdentifier: offer.currency)
    let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
    // TODO: replace with dealer data
    var isCodeValid = true
    var codeValue = 10.00
    
    // TODO: remove invalid promo when we have real data
    if promoTextField.text == "" {
      isCodeValid = false
      codeValue = 0.00
    }

    totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: numberFormatter.number(from: offer.price) as! CGFloat, promoValue: CGFloat(codeValue)))"
    // TODO: update labels here or in calculate method?
    codeValueLabel.text = "\(currencySymbol!) \(String(format: "%.2f", codeValue))"
    promoTextField.resignFirstResponder()
    // TODO: after success
    promoCodeErrorLabel.isHidden = false
    promoCodeSuccess(success: isCodeValid)
  }
  
  func promoCodeSuccess(success: Bool) {
    if success == true {
      promoCodeErrorLabel.text = "Success! Your code has been applied."
      promoCodeErrorLabel.textColor = UIColor(red: 103/255, green: 177/255, blue: 22/255, alpha: 1.0)
    }
    else {
      promoCodeErrorLabel.textColor = UIColor(red: 203/255, green: 100/255, blue: 100/255, alpha: 1.0)
      promoCodeErrorLabel.text = "This code is invalid. Please try again."
    }
  }

}
