//
//  PurchaseConfirmViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/7/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit
import PassKit
import Stripe

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
  @IBOutlet var applePayButton: UIButton!
  
  var discountAmount = "0.0"
  
  let SupportedPaymentNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]
  let ApplePaySwagMerchantID = "merchant.com.sportsrocket.nll.staging.iphone"
  
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
    
    self.edgesForExtendedLayout = []
    super.viewDidLoad()
  }
  
  func setLabelValues() {
    let locale = NSLocale(localeIdentifier: offer.currency)
    let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
    passTitle.text = product.name
    passTypeLabel.text = product.category
    passPriceLabel.text = "\(currencySymbol!) \(offer.price!)"
    taxPriceLabel.text = "$ 0.00"
    totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: CGFloat(offer.price.floatValue), promoValue: 0))"
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
    let totalPrice = (promoValue > orginalPrice) ? 0.0 : (orginalPrice - promoValue)
    return String(format: "%.2f", totalPrice)
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
    let locale = NSLocale(localeIdentifier: offer.currency)
    let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let realm = appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String
    
    if let code = promoTextField.text {
      Coupon.query(realm, withCode: code, accessToken: Session.shared().accessToken, onCompletion: { (coupon, error) in
        if error == nil  {
          if let codeValue = coupon?.discountAmount(self.offer.price) {
            self.discountAmount = "\(codeValue)"
            self.totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: CGFloat(self.offer.price.floatValue), promoValue: CGFloat(codeValue)))"
            self.codeValueLabel.text = "\(currencySymbol!) \(String(format: "%.2f", codeValue))"
            self.promoTextField.resignFirstResponder()
            self.promoCodeErrorLabel.isHidden = false
            self.promoCodeSuccess(success: true)
          }
        } else {
          self.discountAmount = "0.0"
          self.codeValueLabel.text = "\(currencySymbol!) \(String(format: "%.2f", 0.0))"
          self.totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: CGFloat(self.offer.price.floatValue), promoValue: CGFloat(0.0)))"
          self.promoCodeErrorLabel.isHidden = false
          self.promoCodeSuccess(success: false)
        }
      })
    }

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

  @IBAction func userTappedApplePayButton(_ sender: Any) {
    let viewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest())
    viewController.delegate = self
    present(viewController, animated: true)
  }
  
  // MARK: - Apple Pay
  func paymentRequest() -> PKPaymentRequest {
    let request = PKPaymentRequest()
    request.merchantIdentifier   = ApplePaySwagMerchantID
    request.supportedNetworks    = SupportedPaymentNetworks
    request.merchantCapabilities = PKMerchantCapability.capability3DS
    request.countryCode = "US"
    request.currencyCode = "USD"
    request.requiredShippingAddressFields = PKAddressField.all
    request.paymentSummaryItems = paymentSummaryItems(taxAmount: nil)
    return request
  }

  func paymentSummaryItems(taxAmount tax: NSNumber?) -> ([PKPaymentSummaryItem]) {
    let product = PKPaymentSummaryItem(label: self.product.name, amount: NSDecimalNumber(string: "\(offer.price!)"))
    let discount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: self.discountAmount))
    var taxItem: PKPaymentSummaryItem
    var totalAmount = product.amount.subtracting(discount.amount)

    if tax != nil {
      taxItem = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: tax?.stringValue))
      totalAmount = totalAmount.adding(taxItem.amount)
      let total = PKPaymentSummaryItem(label: "NLL", amount: totalAmount)
      return [product, discount, taxItem, total]
    } else {
      let total = PKPaymentSummaryItem(label: "NLL", amount: totalAmount)
      return [product, discount, total]
    }
  }

}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension PurchaseConfirmViewController: PKPaymentAuthorizationViewControllerDelegate {
  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
    STPAPIClient.shared().createToken(with: payment) { (token, error) in
      print(token ?? "no token")
    }
  }

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    dismiss(animated: true)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let realm = appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String
    if let _ = contact.postalAddress {
      if let user = Session.shared().user {
        self.offer.getTaxInfo(["uuid": user.uuid, "email_address": user.email_address], billingInfo: contact.postalAddress?.billingInfo(), accessToken: Session.shared().accessToken, realm: realm) { (response, error) in
          if let tax = response {
            completion(.success, [], self.paymentSummaryItems(taxAmount: tax.taxTotal))
          } else {
            let errorViewController = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
            self.navigationController?.present(errorViewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
}

extension CNPostalAddress {
  func billingInfo() -> [String: String] {
    return [
        "address_postal_code": self.postalCode,
        "address_country": self.country,
        "address_region": self.state,
        "address_city": self.city,
        "address_line_1": self.street,
        "address_line_2": ""
    ]
  }
}
