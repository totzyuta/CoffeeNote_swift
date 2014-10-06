//
//  DetailViewController.swift
//  CoffeeNote
//
//  Created by totz on 10/1/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var blendName: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println("---DetailViewDidLoad---")
    
  }
  
  override func viewWillAppear(animated: Bool) {
    println("---DetailViewWillAppear---")

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate //AppDelegatのインスタンスを取得
    var blendName = appDelegate.blendName
    println(blendName)
    
    self.blendName.text = blendName
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
}
