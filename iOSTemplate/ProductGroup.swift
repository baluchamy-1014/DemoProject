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
  
  init(artifact: Artifact, products: [Product]) {
    self.artifact = artifact
    self.products = products
  }

}
