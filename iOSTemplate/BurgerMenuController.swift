//
// Created by Shovan Joshi on 1/30/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation
import UIKit

class BurgerMenuController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Menu"
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = UITableViewCell(style: .Default, reuseIdentifier: "burgerMenuCell")
    var text = ""
    
    switch indexPath.row {
    case 0:
      text = "Home"
    case 1:
      text = "Favourites"
    case 2:
      text = "Highlights"
    case 3:
      text = "Goals"
    default:
      "Placeholder"
    }

    cell.textLabel?.text = text
    
    return cell
    
  }
  
}