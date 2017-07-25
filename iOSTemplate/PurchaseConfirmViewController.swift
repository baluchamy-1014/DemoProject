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
  @IBOutlet var contentView: UIView!
  @IBOutlet var passTitle: UILabel!
  @IBOutlet var passSubtitle: UILabel!
  @IBOutlet var promoApplyButton: UIButton!
  @IBOutlet var promoTextField: UITextField!
  @IBOutlet var passTypeLabel: UILabel!
  @IBOutlet var passPriceLabel: UILabel!
  @IBOutlet var codeValueLabel: UILabel!
  @IBOutlet var totalPriceLabel: UILabel!
  @IBOutlet var promoCodeErrorLabel: UILabel!
  @IBOutlet var applePayButton: UIButton!
  @IBOutlet var legalTextView: UITextView!
  @IBOutlet var scrollview: UIScrollView!
  var postalAddress: CNPostalAddress?
  
  var discountAmount = "0.0"
  let bottomMargin: CGFloat = 10
  var subTotalAmount: NSDecimalNumber = 0.0
  var totalAmount: NSDecimalNumber = 0.0
  var taxAmount: NSDecimalNumber = 0.0
  
  var freeTransaction = false
  
  let SupportedPaymentNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]
  
  var product: Product!
  var offer: Offer!
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate


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
    totalPriceLabel.text = "\(currencySymbol!) \(self.calculateSum(orginalPrice: CGFloat(offer.price.floatValue), promoValue: 0))"
    legalTextView.text = DataFromTextFile().readDataFromFile(file: "PassFooter")
    legalTextView.sizeToFit()
  }
  
  override func viewDidLayoutSubviews()
  {
    scrollview.contentSize = CGSize(width: self.view.bounds.width, height: legalTextView.frame.origin.y + legalTextView.frame.height + bottomMargin)
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
            if self.totalAmount.decimalValue <= 0.0 {
              self.applePayButton.setImage(UIImage(named: "transactionButton"), for: UIControlState())
            }
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
    self.freeTransaction = success
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
    if self.freeTransaction {
      let realm = appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String
      self.offer.purchase(self.transactionInfo(token: nil), forRealm: realm, withAccessToken: Session.shared().accessToken, onCompletion: { (transactions, error) in
        if (error == nil) {
          let successViewController = SuccessViewController(nibName: "SuccessViewController", bundle: nil)
          self.navigationController?.present(successViewController, animated: true, completion: nil)
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.dismiss(animated: true, completion: {
              if self.appDelegate.throughBurgerMenu == true {
                self.appDelegate.sendUserToHomeScreen()
              }
              else {
                self.returnToDetailScreen()
              }
            })
          }
        } else {
          let errorViewController = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
          self.navigationController?.present(errorViewController, animated: true, completion: nil)
        }
      })
    } else {
      let viewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest())
      viewController.delegate = self
      present(viewController, animated: true)
    }
  }
  
  // MARK: - Apple Pay
  func paymentRequest() -> PKPaymentRequest {
    let request = PKPaymentRequest()
    request.merchantIdentifier   = appDelegate.appConfiguration["ApplePayMerchantID"] as! String
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
    subTotalAmount = product.amount.subtracting(discount.amount)

    if tax != nil {
      taxAmount = NSDecimalNumber(string: tax?.stringValue)
      taxItem = PKPaymentSummaryItem(label: "Tax", amount: taxAmount)
      totalAmount = subTotalAmount.adding(taxItem.amount)
      let total = PKPaymentSummaryItem(label: "NLL", amount: totalAmount)
      return [product, discount, taxItem, total]
    } else {
      totalAmount = subTotalAmount
      let total = PKPaymentSummaryItem(label: "NLL", amount: totalAmount)
      return [product, discount, total]
    }
  }
  
  func returnToDetailScreen() {
    for viewController in (self.navigationController?.viewControllers)! {
      if viewController.isKind(of: DetailViewController.self) {
        let detailVC = viewController as! DetailViewController
        detailVC.videoPlayerState = .NotReady
        for view in detailVC.headerImageView.subviews {
          view.removeFromSuperview()
        }
        detailVC.headerImageView.addSubview(detailVC.button)
        detailVC.headerImageView.addSubview(detailVC.activityIndicator)
        detailVC.activityIndicator.stopAnimating()
        self.navigationController?.popToViewController(detailVC, animated: true)
      }
    }
  }

  func resetAmountValues() {
    subTotalAmount = 0.0
    totalAmount = 0.0
    taxAmount = 0.0
  }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension PurchaseConfirmViewController: PKPaymentAuthorizationViewControllerDelegate {
  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
    STPAPIClient.shared().createToken(with: payment) { (token, error) in
      if (token != nil) {
        let realm = self.appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String
        self.offer.purchase(self.transactionInfo(token: token!), forRealm: realm, withAccessToken: Session.shared().accessToken, onCompletion:  { (transactions, error) in
          if (error == nil) {
            completion(.success)
            self.dismiss(animated: true, completion: {
              let successViewController = SuccessViewController(nibName: "SuccessViewController", bundle: nil)
              self.navigationController?.present(successViewController, animated: true, completion: nil)
              DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.dismiss(animated: true, completion: {
                  if self.appDelegate.throughBurgerMenu == true {
                    self.appDelegate.sendUserToHomeScreen()
                  }
                  else {
                    self.returnToDetailScreen()
                  }
                })
              }
            })
          } else {
            completion(.failure)
          }
        })
      }
    }
  }

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    dismiss(animated: true)
    resetAmountValues()
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
    let realm = appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String
    if let _ = contact.postalAddress {
      if let user = Session.shared().user {
        self.postalAddress = contact.postalAddress
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

extension PurchaseConfirmViewController {
  func transactionInfo(token: STPToken?) -> [String: Any] {
    let subTotalAmountString: String = self.subTotalAmount.stringValue
    let totalAmountString: String = self.totalAmount.stringValue
    let taxAmountString: String = self.taxAmount.stringValue
    let couponCode = (self.promoTextField.text != nil) ? self.promoTextField.text! : ""
    var transactionInfo: [String: Any] = [String:Any]()
    transactionInfo = [
        "provider": "Stripe",
        "type_name": "purchase_transaction",
        "subtotal": subTotalAmountString,
        "subtotal_usd": subTotalAmountString,
        "tax": taxAmountString,
        "total": totalAmountString,
        "currency": "USD",
        "product_id": self.product.id.stringValue,
        "offer_id": self.offer.id.stringValue,
        "offer_uuid": self.offer.uuid,
    ]
    if couponCode != "" {
      transactionInfo["coupon_code"] = couponCode
    }
    if (token == nil) {
      // do nothing
    } else {
      transactionInfo["token"] = token!.transactionInfo()
      transactionInfo["address"] = self.postalAddress!.billingInfo()
    }

    transactionInfo["device_platform"] = "iOS"
    return transactionInfo
  }
}
