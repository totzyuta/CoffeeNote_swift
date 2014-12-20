//
//  Config.swift
//  CoffeeNote
//
//  Created by totz on 11/8/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import Foundation

class Config: UITableViewCell {
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
  
  func setAdUnitId() -> String {
    let AD_UNIT_ID: String = "ca-app-pub-4052843231042111/7994489581"
    return AD_UNIT_ID
  }

}