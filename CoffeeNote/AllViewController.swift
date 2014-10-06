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
    
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // セルに表示するテキスト
  let texts = ["House Blend", "Pike Place Roast", "Light Note", "Kenya", "Ethiopia", "Espresso Blend", "Brazil"]
  
  // セルの行数
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return texts.count
  }
  
  // セルの内容を変更
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    
    cell.textLabel?.text = texts[indexPath.row]
    return cell
  }
  
  
  @IBAction func unwindToAllByCancel(segue: UIStoryboardSegue) {
    NSLog("unwindToAllByCancel was called")
  }

  @IBAction func unwindToAllBySave(segue: UIStoryboardSegue) {
        NSLog("unwindToAllBySave was called")
  }

  
}

