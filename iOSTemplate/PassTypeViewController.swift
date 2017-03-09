//
//  PassTypeViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/6/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class PassTypeViewController: UITableViewController {

  override func viewDidLoad() {
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor.black
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: 3 through burger menu, 4 through playback
    return 3
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! TicketTableViewCell
    // TODO: remove hardcoded and add from SDK
    switch indexPath.row {
    case 0:
      cell.passLeadingImage.image = UIImage(named: "ticketTailSingle")
      cell.passTrailingImage.image = UIImage(named: "singleButton")
    case 1:
      cell.passLeadingImage.image = UIImage(named: "ticketTailSeason")
      cell.passTrailingImage.image = UIImage(named: "seasonButton")
      cell.passTopBorderView.backgroundColor = UIColor(red: 92/255, green: 19/255, blue: 20/255, alpha: 1.0)
      cell.passBottomBorderView.backgroundColor = UIColor(red: 92/255, green: 19/255, blue: 20/255, alpha: 1.0)
      cell.passTitle.text = "NLL TV Season Pass"
      cell.passSubtitle.text = "2017 League Season Pass"
    case 2:
      cell.passLeadingImage.image = UIImage(named: "ticketTailTeam")
      cell.passTrailingImage.image = UIImage(named: "teamButton")
      cell.passTopBorderView.backgroundColor = UIColor(red: 69/255, green: 93/255, blue: 113/255, alpha: 1.0)
      cell.passBottomBorderView.backgroundColor = UIColor(red: 69/255, green: 93/255, blue: 113/255, alpha: 1.0)
      cell.passTitle.text = "Team Season Pass"
      cell.passSubtitle.text = "Team Season Pass"
      cell.passPrice.text = "$29.99"
    default:
      break
    }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
