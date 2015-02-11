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
    
    // change title of navigation bar
    var title = UILabel()
    title.font = UIFont.boldSystemFontOfSize(16)
    title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    title.text = NSLocalizedString("titleAboutView", comment: "comment")
    title.sizeToFit()
    self.navigationItem.titleView = title;
    
    if (lang as NSString=="en") {
      aboutThisAppLabel.text = NSLocalizedString("aboutThisAppLabel", comment: "comment")
      aboutThisAppTextView.text = NSLocalizedString("aboutThisAppTextView", comment: "comment")
      aboutThisAppTextView.font = UIFont(name: "HelveticaNeue", size: 20)
      aboutThisAppTextView.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
      forUsersLabel.text = NSLocalizedString("forUsersLabel", comment: "comment")
      forUsersTextView.text = NSLocalizedString("forUsersTextView", comment: "comment")
      forUsersTextView.font = UIFont(name: "HelveticaNeue", size: 20)
      forUsersTextView.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
      urlLabel.text = NSLocalizedString("urlLabel", comment: "comment")
      forUsersTextView2.text = NSLocalizedString("forUsersTextView2", comment: "comment")
      forUsersTextView2.font = UIFont(name: "HelveticaNeue", size: 20)
      forUsersTextView2.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
    }

  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func urlButtonPushed(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://coffee-note.com/ios/index.html")!)
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
