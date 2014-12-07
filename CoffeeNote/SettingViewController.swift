//
//  SettingViewController.swift
//  CoffeeNote
//
//  Created by totz on 11/18/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var settingTableview: UITableView!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var phraseLabel: UILabel!
  @IBOutlet weak var informationLabel: UILabel!
  @IBOutlet weak var allNotesLabel: UILabel!
  @IBOutlet weak var supportLabel: UILabel!
  
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
      
      appNameLabel.text = NSLocalizedString("AppName", comment: "comment")
      phraseLabel.text = NSLocalizedString("Phrase",comment: "comment")
      informationLabel.text = NSLocalizedString("Information", comment: "comment")
      allNotesLabel.text = NSLocalizedString("AllNotes", comment: "comment")
      
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
  
  // Set the contents of cells
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell: SettingCell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as SettingCell
    
    switch(indexPath.row) {
    case 0:
      cell.settingLabel.text = "Report a Bug"
      break
    case 1:
      cell.settingLabel.text = NSLocalizedString("TwitterSupport", comment: "comment")
      break
    case 2:
      cell.settingLabel.text = NSLocalizedString("SayHi", comment: "comment")
      break
    default:
      cell.settingLabel.text = "Hello"
      break
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    switch(indexPath.row) {
    case 0:
      // TODO: Open a mailer for but reporting system
      break
    case 1:
      UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/CoffeeNote_info/")!)
      break
    case 2:
      UIApplication.sharedApplication().openURL(NSURL(string: NSLocalizedString("twitterURL", comment: "comment"))!)
      break
    default:
      break
    }
    
  }
  
  
  // return number of cell
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

}
