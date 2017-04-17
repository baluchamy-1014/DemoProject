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
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor.black
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 138
    self.title = "Purchase Options"
    
    setupHeaderView()
    setupFooterView()

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

  func applyCellSettings(cell: TicketTableViewCell, product: Product, passTitle: String) {
    if let offer = product.offers[0] as? Offer {

     switch product.category {
      case "single-game":
        cell.passLeadingImage.image = UIImage(named: "ticketTailSingle")
        cell.passTrailingImage.image = UIImage(named: "singleButton")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        cell.passSubtitle.text = dateFormatter.string(from: product.startsAt)
      case "season":
        cell.passLeadingImage.image = UIImage(named: "ticketTailSeason")
        cell.passTrailingImage.image = UIImage(named: "seasonButton")
        cell.passTopBorderView.backgroundColor = UIColor(red: 92 / 255, green: 19 / 255, blue: 20 / 255, alpha: 1.0)
        cell.passBottomBorderView.backgroundColor = UIColor(red: 92 / 255, green: 19 / 255, blue: 20 / 255, alpha: 1.0)
        cell.passSubtitle.text = "2016 League Season Pass"
      case "team":
        cell.passLeadingImage.image = UIImage(named: "ticketTailTeam")
        cell.passTrailingImage.image = UIImage(named: "teamButton")
        cell.passTopBorderView.backgroundColor = UIColor(red: 69 / 255, green: 93 / 255, blue: 113 / 255, alpha: 1.0)
        cell.passBottomBorderView.backgroundColor = UIColor(red: 69 / 255, green: 93 / 255, blue: 113 / 255, alpha: 1.0)
        cell.passSubtitle.text = "Team Season Pass"
        cell.passPrice.text = "$29.99"
      default:
        break
      }

      cell.passTitle?.text = passTitle

      cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 200)
      cell.contentView.bounds = cell.bounds
      cell.layoutIfNeeded()
      cell.passTitle.sizeToFit()

      if let price = offer.price {
        let locale = NSLocale(localeIdentifier: offer.currency)
        let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
        cell.passPrice.text = "\(currencySymbol!) \(price)"
      }
    }

  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! TicketTableViewCell

    if let productGroup = subscriptionItems[indexPath.row] as? ProductGroup {
      if let product = productGroup.products[0] as? Product {
        applyCellSettings(cell: cell, product: product, passTitle: productGroup.artifact.name)
      }
    } else if let product = subscriptionItems[indexPath.row] as? Product {
      applyCellSettings(cell: cell, product: product, passTitle: product.name)
    }

    return cell
  }
  
  func setupHeaderView() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
    let label = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: 24))
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 22.0)
    label.text = "Find Your Perfect Pass"
    label.textColor = UIColor.white
    view.backgroundColor = UIColor.black
    view.addSubview(label)
    
    tableView.tableHeaderView = view
  }
  
  func setupFooterView() {
    let view = UIView(frame: CGRect(x: 0, y: tableView.frame.size.height - 20, width: tableView.frame.size.width, height: 65))
    let label = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: 24))
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 12.0)
    label.text = "Legal stuff, blackout info, etc."
    label.textColor = UIColor.white
    view.backgroundColor = UIColor.black
    view.addSubview(label)
    
    tableView.tableFooterView = view
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = subscriptionItems[indexPath.row] as? Product {
      if let offer = item.offers[0] as? Offer {
        // TODO: check if logged in
        let viewController = PurchaseConfirmViewController(product: item, anOffer: offer)
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.title = "Purchase Confirmation"

        switch item.category {
        case "single-game":
          viewController.view.backgroundColor = UIColor(red: 167 / 255, green: 147 / 255, blue: 25 / 255, alpha: 1.0)
          // TODO: create central date formatter class
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMMM d, yyyy"
          viewController.passSubtitle.text = dateFormatter.string(from: item.startsAt)

            // only if through burger menu
            //      let viewController = SingleGamePassViewController(product: item, anOffer: offer)
            //      self.navigationController?.pushViewController(viewController, animated: true)
        case "season":
          viewController.view.backgroundColor = UIColor(red: 92 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1.0)
          viewController.passTitle.text = item.name.uppercased()
          viewController.passSubtitle.text = "2016 League Season Pass"
        case "team":
          viewController.view.backgroundColor = UIColor(red: 84 / 255, green: 112 / 255, blue: 135 / 255, alpha: 1.0)
          // TODO: find out where subtitle comes from
          viewController.passSubtitle.text = item.category
          // TODO: team filter when from burger menu
          break
        default:
          break
        }
      }
    } else if let productGroup = subscriptionItems[indexPath.row] as? ProductGroup {
      let passController = PassTypeViewController()
      self.navigationController?.pushViewController(passController, animated: true)
      self.title = ""
      passController.subscriptionItems = productGroup.products
      passController.tableView.reloadData()
    }
  }
}
