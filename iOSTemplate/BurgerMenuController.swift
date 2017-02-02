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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = UITableViewCell(style: .default, reuseIdentifier: "burgerMenuCell")
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
