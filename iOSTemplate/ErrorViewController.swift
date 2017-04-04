//
//  ErrorViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 4/3/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
  @IBOutlet var errorOKButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func userDidTapOKButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
