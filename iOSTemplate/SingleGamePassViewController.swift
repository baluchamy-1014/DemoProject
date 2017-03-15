//
//  SingleGamePassViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/7/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class SingleGamePassViewController: UITableViewController {

  override func viewDidLoad() {
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor.black
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // TODO: number from API
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 138.0
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! TicketTableViewCell

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: check if logged in
    let viewController = PurchaseConfirmViewController()
    self.navigationController?.pushViewController(viewController, animated: true)
    // TODO: remove hardcoded
    viewController.view.backgroundColor = UIColor(red: 167/255, green: 147/255, blue: 25/255, alpha: 1.0)
    viewController.title = "Purchase Confirmation"
    viewController.passTitle.text = "Toronto vs Vancouver".uppercased()
    viewController.passSubtitle.text = "Jan 5th, 2017 @ 5:00 PM"
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // TODO: need dates
    return "January 5th, 2017"
  }

}
