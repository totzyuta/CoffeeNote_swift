//
//  CustomCell.swift
//  CoffeeNote
//
//  Created by totz on 10/13/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var backImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setCell(titleLabel: String, imageName: String)
  {
    self.titleLabel.text = titleLabel
    self.backImage.image = UIImage(named: imageName)
  }

}
