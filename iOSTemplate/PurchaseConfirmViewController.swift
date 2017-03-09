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
  
  override func viewDidLoad() {
    promoApplyButton.layer.borderColor = UIColor.lightGray.cgColor
    promoApplyButton.layer.borderWidth = 1.0
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PurchaseConfirmViewController.cancelPurchase))

    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func cancelPurchase() {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
