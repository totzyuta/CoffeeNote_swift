//
//  ViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var allTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    allTableView.delegate = self
    allTableView.dataSource = self
    
    
    // NSUserDefaultsインスタンスの生成
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // キーが"saveText"のStringをとります。
    var loadText : String! = userDefaults.stringForKey("saveText")
    
    // labelに表示
    println("Saved: " + loadText)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // セルに表示するテキスト
  let blendNames = ["House Blend", "Pike Place Roast", "Light Note", "Kenya", "Ethiopia", "Espresso Blend", "Brazil"]
  
  // セルの行数
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return blendNames.count
  }
  
  // セルの内容を変更
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    
    cell.textLabel?.text = blendNames[indexPath.row]
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("toDetailViewController was called")

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegateのインスタンスを取得
    appDelegate.blendName = blendNames[indexPath.row] //appDelegateの変数を操作
    
    performSegueWithIdentifier("toDetailViewController", sender: self)
    
  }
  
  @IBAction func unwindToAllByCancel(segue: UIStoryboardSegue) {
    NSLog("unwindToAllByCancel was called")
  }

  @IBAction func unwindToAllBySave(segue: UIStoryboardSegue) {
    NSLog("unwindToAllBySave was called")
  }

  
}

