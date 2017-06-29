//
//  PassTypeViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/6/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class PassTypeViewController: UITableViewController, UserSessionDelegate {
  var subscriptionItems: [AnyObject] = Array()
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  var selectedIndexPath = NSIndexPath()
  
  override func viewDidLoad() {
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor.black
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 138
    
    setupHeaderView()
    setupFooterView()
    setupActivitySpinner()
    
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.title = "Purchase Options"
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.isTranslucent = false
    super.viewWillAppear(true)
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
    
      if let category = product.category {
        switch category {
        case "single":
          cell.passLeadingImage.image = UIImage(named: "ticketTailSingle")
          cell.passTrailingImage.image = UIImage(named: "singleButton")
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMMM d, yyyy"
          if product.startsAt != nil {
            cell.passSubtitle.text = dateFormatter.string(from: product.startsAt)
          }
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
        default:
          break
        }
      } else {
        print("AAAAA \(product.name)")
      }

      cell.passTitle?.text = passTitle

      cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 200)
      cell.contentView.bounds = cell.bounds
      cell.layoutIfNeeded()

      if let offers = product.offers as? [Offer] {
        if offers.count > 0 {
          let offer = offers[0]
          if let price = offer.price {
            let locale = NSLocale(localeIdentifier: offer.currency)
            let currencySymbol = locale.displayName(forKey: .currencySymbol, value: offer.currency)
            cell.passPrice.text = "\(currencySymbol!) \(price)"
          }
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
    activityIndicator.stopAnimating()
    tableView.tableFooterView?.isHidden = false
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
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 165))
    footerView.backgroundColor = UIColor.black
    
    let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 24))
    footerLabel.text = "*BLACKOUT POLICIES MAY APPLY"
    footerLabel.textColor = .white
    footerLabel.font = UIFont.systemFont(ofSize: 12.0)
    footerLabel.textAlignment = .center
    footerView.addSubview(footerLabel)

    let footerTextView = UITextView(frame: CGRect(x: 10, y: 24, width: view.frame.size.width - 20, height: 124))
    footerTextView.textAlignment = .center
    footerTextView.font = UIFont.systemFont(ofSize: 12.0)
    footerTextView.text = DataFromTextFile().readDataFromFile(file: "PassFooter")
    footerTextView.textColor = UIColor.white
    footerTextView.backgroundColor = .clear
    footerTextView.isEditable = false

    footerView.addSubview(footerTextView)
    
    tableView.tableFooterView = footerView
    tableView.tableFooterView?.isHidden = true
  }
  
  func setupActivitySpinner() {
    tableView?.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -20))
    activityIndicator.startAnimating()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = subscriptionItems[indexPath.row] as? Product {
      if let offers = item.offers as? [Offer] {
        if offers.count > 0 {
          let offer = offers[0]
          let viewController = PurchaseConfirmViewController(product: item, anOffer: offer)
          viewController.title = "Purchase Confirmation"

          switch item.category {
          case "single":
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
            break
          default:
            break
          }
          if Session.shared().isValid() {
            self.navigationController?.pushViewController(viewController, animated: true)
          }
          else {
            let alertController = UIAlertController(title: "Sign In Required!", message: "We're rerouting you to the\nSign In/Sign Up page", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(noAction)
            let yesAction = UIAlertAction(title: "OK", style: .default) { action in
            let userController = UserController(nibName: "UserAccount", bundle: nil)
            userController.sessionDelegate = self
            self.selectedIndexPath = indexPath as NSIndexPath
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0) // this
            self.navigationController?.pushViewController(userController, animated: true)
            }
          alertController.addAction(yesAction)
          self.present(alertController, animated: true, completion: nil)
          }
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
  
  func userDidSignIn() {
    goToConfirmScreen()
  }
  
  private func goToConfirmScreen() {
    tableView(tableView, didSelectRowAt: selectedIndexPath as IndexPath)
  }
}
