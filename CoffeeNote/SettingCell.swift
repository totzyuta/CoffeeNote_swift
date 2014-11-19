//
//  SettingCell.swift
//  CoffeeNote
//
//  Created by totz on 11/19/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

  @IBOutlet weak var settingLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setCell(settingLabel: String)
  {
    self.settingLabel.text = settingLabel
  }

}
