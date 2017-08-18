//
//  SeasonsViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 5/11/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class SeasonsViewController: UITableViewController {
  var seasonItems: [AnyObject] = Array()
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
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
    self.title = "Choose Your Season"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return seasonItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "SeasonTicketCell", bundle: nil), forCellReuseIdentifier: "SeasonTicketCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonTicketCell", for: indexPath) as! SeasonTicketCell
    cell.backgroundColor = .black
    if seasonItems.count > 0 {
      if let item = seasonItems[indexPath.row] as? Group {
        cell.seasonPassTitle.text = item.name
      }
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
    label.text = "Choose Your Season"
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
   if let seasonGroup = seasonItems[indexPath.row] as? Group {
      let passController = PassTypeViewController()
      self.navigationController?.pushViewController(passController, animated: true)

      Product.query(self.appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String, archivistCategoryUids: [seasonGroup.uid]) { productsByUids, error in
        var values: [ProductGroup] = []
        Artifact.getRelatedArtifacts(Int32(Int((seasonGroup.id)!)), forProperty: seasonGroup.propertyID, filter: ["count": "20"]) { items, error in
          print(items!)
          for item in (items! as! [Artifact]) {
            print("item name is \(item.name) uid is : \(item.uid) and \(productsByUids)")
            if let products = (productsByUids as! [String:AnyObject])[item.uid] {
              let productGroup = ProductGroup(artifact: item, products: products as! [Product])
              print(products)
              values.append(productGroup)
            }
          }
          passController.subscriptionItems = values
          passController.tableView.reloadData()
        }
      }
    }
  }
  // TODO: open error modal
  //let errorViewController = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
  // self.navigationController?.present(errorViewController, animated: true, completion: nil)
   //   }
}
