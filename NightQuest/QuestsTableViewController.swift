//
//  QuestsTableViewController.swift
//  NightQuest
//
//  Created by Admin on 05.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation
import UIKit

class QuestsTableViewController :UITableViewController, UITableViewDelegate, UITableViewDataSource {

    required init(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)
        server.tryGetQuestsList("new,now",callback: OnQListRecived)
    }
    /*required init(style:)
    {*/
    //var quets = ["We", "Heart", "Swift"]
    var quests:[[String:AnyObject]]?
    var choosenID="0"
    @IBOutlet var QTable: UITableView!
    @IBOutlet weak var Progress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      //  Progress.startAnimating()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "QuestsToQuest") {
            let vc = segue.destinationViewController as QuestViewController
            vc.myID = choosenID
        }
    }
    func OnQListRecived(json:NSDictionary)
    {
        Progress.stopAnimating()
        if json["code"] as String == "ok" {
            var err: NSError?
            let jsonObject = NSJSONSerialization.JSONObjectWithData(
                (json["quests"] as String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,
                options: NSJSONReadingOptions.MutableContainers, error: &err)
            quests = jsonObject! as [[String:AnyObject]]
            QTable.reloadData()
        } else {
            println("error getting quests")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.quests != nil {
            println(self.quests!.count)
            return self.quests!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let ok = quests!
        let a:String = (ok[indexPath.row] as [String:String])["name"]!
        let b:String = (ok[indexPath.row] as [String:String])["time"]!
        cell.textLabel.text = a + " (" + b + ") "
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ok = quests!
        choosenID = (ok[indexPath.row] as [String:String])["id"]!
        self.performSegueWithIdentifier("QuestsToQuest",sender: self)
    }
}