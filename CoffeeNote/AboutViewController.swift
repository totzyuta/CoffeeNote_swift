//
//  AboutViewController.swift
//  CoffeeNote
//
//  Created by totz on 12/9/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit
import Foundation

class AboutViewController: UIViewController {

  @IBOutlet weak var aboutThisAppLabel: UILabel!
  @IBOutlet weak var aboutThisAppTextView: UITextView!
  @IBOutlet weak var forUsersLabel: UILabel!
  @IBOutlet weak var forUsersTextView: UITextView!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var forUsersTextView2: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var lang: AnyObject = NSLocale.preferredLanguages()[0]
    
    if (lang as NSString=="en") {
      aboutThisAppLabel.text = NSLocalizedString("aboutThisAppLabel", comment: "comment")
      aboutThisAppTextView.text = NSLocalizedString("aboutThisAppTextView", comment: "comment")
      forUsersLabel.text = NSLocalizedString("forUsersLabel", comment: "comment")
      forUsersTextView.text = NSLocalizedString("forUsersTextView", comment: "comment")
      urlLabel.text = NSLocalizedString("urlLabel", comment: "comment")
      forUsersTextView2.text = NSLocalizedString("forUsersTextView2", comment: "comment")
      aboutThisAppLabel.font = UIFont(name: "HiraKakuProN-W3", size: 32.0)
    }

  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func urlButtonPushed(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://coffee-note.com/ios/wishlist")!)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
