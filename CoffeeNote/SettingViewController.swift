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
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
      cell.settingLabel.text = "Twitter Support"
      break
    case 1:
      cell.settingLabel.text = "Say Hi to Developer"
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
      UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/CoffeeNote_info/")!)
      break
    case 1:
      UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/totu_iy/")!)
      break
    default:
      break
    }
    
  }
  
  
  // return number of cell
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

}
