//
//  Photohunt.swift
//  NightQuest
//
//  Created by Admin on 20.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit


class Photohunt: UIViewController, UITableViewDelegate, UITableViewDataSource  {//
    
    @IBOutlet weak var Picture: UIWebView!
    @IBOutlet weak var Codes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Ready(sender: AnyObject) {
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0//4
    }
    
     func tableView(tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
     func titleForHeaderInSection(tableView: UITableView,  section: Int) -> String? {
        return nil
    }
     func didSelectRowAtIndexPath(tableView: UITableView,  indexPath: NSIndexPath) {
        // все равно тут ничего не делается - наступление квеста авоматически проверяется
    }
}