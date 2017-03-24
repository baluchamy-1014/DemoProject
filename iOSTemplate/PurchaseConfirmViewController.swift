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
    print(offer.price)
    passPriceLabel.text = "\(currencySymbol!) \(offer.price!)"
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
    let taxNum = (orginalPrice - promoValue) * CGFloat(0.095)
  // TODO: find out where tax comes from and replace
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
    // TODO: add check to see if promo code is valid
    promoCodeErrorLabel.isHidden = false
    
  }

}
