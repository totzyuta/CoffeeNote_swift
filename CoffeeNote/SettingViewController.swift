//
//  SettingViewController.swift
//  CoffeeNote
//
//  Created by totz on 11/18/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var appNameTextView: UITextView!
  @IBOutlet weak var phraseLabel: UILabel!
  @IBOutlet weak var phraseTextView: UITextView!
  @IBOutlet weak var informationLabel: UILabel!
  @IBOutlet weak var allNotesLabel: UILabel!
  @IBOutlet weak var aboutLabel: UILabel!
  @IBOutlet weak var supportLabel: UILabel!
  @IBOutlet weak var reportLabel: UILabel!
  @IBOutlet weak var supportAccountLabel: UILabel!
  @IBOutlet weak var contactLabel: UILabel!
  
  @IBOutlet weak var numberNotes: UILabel!
  
    override func viewDidLoad() {
      super.viewDidLoad()

      self.supportLabel.text = NSLocalizedString("Support", comment: "comment")
      
      // change title of navigation bar
      var title = UILabel()
      title.font = UIFont.boldSystemFontOfSize(16)
      // title.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
      title.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
      title.text = NSLocalizedString("titleSettingView", comment: "comment")
      title.sizeToFit()
      self.navigationItem.titleView = title;
      
      var lang: AnyObject = NSLocale.preferredLanguages()[0]
    
      if (lang as NSString=="ja") {
        appNameLabel.hidden = true
        phraseLabel.hidden = true
      }else {
        appNameTextView.hidden = true
        phraseTextView.hidden = true
      }
      
      
      informationLabel.text = NSLocalizedString("Information", comment: "comment")
      allNotesLabel.text = NSLocalizedString("AllNotes", comment: "comment")
      aboutLabel.text = NSLocalizedString("aboutThisAppLabel", comment: "comment")
      supportAccountLabel.text = NSLocalizedString("TwitterSupport", comment: "comment")
      reportLabel.text = NSLocalizedString("ReportBug", comment: "comment")
      contactLabel.text = NSLocalizedString("SayHi", comment: "comment")
      
    }
  
  override func viewWillAppear(animated: Bool) {
    // sql from here
    let _dbfile:NSString = "sqlite.db"
    let _dir:AnyObject = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true)[0]
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    let _path:String = _dir.stringByAppendingPathComponent(_dbfile)
    
    let db = FMDatabase(path: _path)
    
    
    let sql_select = "SELECT * FROM notes"
    
    db.open()
    
    var rows = db.executeQuery(sql_select, withArgumentsInArray: nil)
    var flg = 0
    // fetch data and put data into label
    while rows.next() {
      flg = flg + 1
    }
    
    numberNotes.text = String(flg)
    
    db.close()
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  
  @IBAction func reportButtonPushed(sender: AnyObject) {
    // check if can send an email
    if MFMailComposeViewController.canSendMail()==false {
      println("Email Send Failed")
      return
    }
    var mailViewController = MFMailComposeViewController()
    mailViewController.mailComposeDelegate = self
    mailViewController.setSubject("Bug Report")
    var toRecipients = ["yuta.totz@gmail.com"]
    mailViewController.setToRecipients(toRecipients)
    mailViewController.setMessageBody(NSLocalizedString("bugReportBody", comment: "comment"), isHTML: false)
    self.presentViewController(mailViewController, animated: true, completion: nil)
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    
    switch result.value {
    case MFMailComposeResultCancelled.value:
      println("Email Send Cancelled")
      break
    case MFMailComposeResultSaved.value:
      println("Email Saved as a Draft")
      break
    case MFMailComposeResultSent.value:
      println("Email Sent Successfully")
      break
    case MFMailComposeResultFailed.value:
      println("Email Send Failed")
      break
    default:
      break
    }
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func supportAccountButtonPushed(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/CoffeeNote_jp/")!)
  }
  
  @IBAction func contactButtonPushed(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: NSLocalizedString("twitterURL", comment: "comment"))!)
  }
  

}
