//
//  PassTypeViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/6/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class PassTypeViewController: UITableViewController {
  var subscriptionItems: [AnyObject] = Array()
  
  override func viewDidLoad() {
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor.black
    self.title = "Purchase Options"
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subscriptionItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! TicketTableViewCell
    // TODO: remove hardcoded and add from SDK
    let item = subscriptionItems[indexPath.row] as! Product

    switch item.category {
    case "single-game":
      cell.passLeadingImage.image = UIImage(named: "ticketTailSingle")
      cell.passTrailingImage.image = UIImage(named: "singleButton")
   //   cell.passSubtitle.text = "Replace With Date from API"
    case "season":
      cell.passLeadingImage.image = UIImage(named: "ticketTailSeason")
      cell.passTrailingImage.image = UIImage(named: "seasonButton")
      cell.passTopBorderView.backgroundColor = UIColor(red: 92/255, green: 19/255, blue: 20/255, alpha: 1.0)
      cell.passBottomBorderView.backgroundColor = UIColor(red: 92/255, green: 19/255, blue: 20/255, alpha: 1.0)
      cell.passSubtitle.text = "2016 League Season Pass"
    case "team":
      cell.passLeadingImage.image = UIImage(named: "ticketTailTeam")
      cell.passTrailingImage.image = UIImage(named: "teamButton")
      cell.passTopBorderView.backgroundColor = UIColor(red: 69/255, green: 93/255, blue: 113/255, alpha: 1.0)
      cell.passBottomBorderView.backgroundColor = UIColor(red: 69/255, green: 93/255, blue: 113/255, alpha: 1.0)
      cell.passSubtitle.text = "Team Season Pass"
      cell.passPrice.text = "$29.99"
    default:
      break
    }
    cell.passTitle?.text = item.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 138.0
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Is there a header or not here?"
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Legal stuff, blackout info, etc."
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      let viewController = SingleGamePassViewController()
      self.navigationController?.pushViewController(viewController, animated: true)
    case 1:
      // TODO: check if logged in
      let viewController = PurchaseConfirmViewController()
      self.navigationController?.pushViewController(viewController, animated: true)
      
      viewController.view.backgroundColor = UIColor(red: 92/255, green: 20/255, blue: 20/255, alpha: 1.0)
      viewController.title = "Purchase Confirmation"
      viewController.passTitle.text = "NLL TV Season Pass".uppercased()
      viewController.passSubtitle.text = "2016 League Season Pass"
    default:
      break
    }
  }
  
}
