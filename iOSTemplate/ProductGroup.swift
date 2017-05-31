//
//  ProductGroup.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 4/6/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import Foundation

class ProductGroup {
  let artifact: Artifact
  let products: [Product]
  var category : String?
  
  
  init(artifact: Artifact, products: [Product]) {
    self.artifact = artifact
    self.products = products
    
    if let artifactName = self.artifact.name {
      category = ProductGroup.categoryType(artifactName: artifactName)
    }
    
    for product in self.products {
      product.category = category
    }
  }
  
  class func applyCategoryToProducts(categoryProducts: [String:Artifact], products: [Product]) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    for product in products {
      for categoryUID in product.archivistCategoryUIDS() {
        if let artifact = appDelegate.archivistProductCategories[categoryUID as! String] {
          if let artifactName = artifact.name {
            product.category = self.categoryType(artifactName: artifactName)
          }
        }
      }
    }
  }
  
  class func categoryType(artifactName: String) -> String {
    var categoryType = ""
    if artifactName.lowercased().range(of:"season") != nil {
      categoryType = "season"
    } else if artifactName.lowercased().range(of:"team") != nil {
      categoryType = "team"
    } else if artifactName.lowercased().range(of:"single") != nil {
      categoryType = "single"
    }
    return categoryType
  }

}
