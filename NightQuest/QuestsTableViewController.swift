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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        server.tryGetQuestsList("new",callback: OnQListRecived)
    }
    /*required init(style:)
    {*/
    //var quets = ["We", "Heart", "Swift"]
    var quests:[[String:String]]?
    var choosenID="0"
    @IBOutlet var QTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
   //     // Do any additional setup after loading the view, typically from a nib.
   /* self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "QCell")*/
      //  Progress.startAnimating()
       // QTable.style = UITableViewStyle.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "QuestsToQuest") {
            let vc = segue.destinationViewController as QuestViewController
            vc.myID = choosenID
        }
    }
    func OnQListRecived(json:NSDictionary)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if json["code"] as String == "ok" {
            var err: NSError?
            quests = json["quests"] as [[String:String]]?
            QTable.reloadData()
        } else {
            println("error getting quests")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        if self.quests != nil {
           // println(self.quests!.count)
            return self.quests!.count
        } else {
            return 0
        }
        } else if section == 1
        {
            return 1
        }
        return 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("QCell") as UITableViewCell
        if indexPath.section == 0 {
            if quests != nil && indexPath.row < quests!.count
            {
                cell.textLabel.text = quests![indexPath.row]["name"]!
                cell.detailTextLabel!.text =  quests![indexPath.row]["time"]!
            }
        }
        if quests != nil {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel.text = "Купить квесты"
                cell.detailTextLabel!.text = ""
            }
          }
        }
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Доступные квесты"
        } else if section == 1 {
            return "Действия"
        }
        return nil
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
        if indexPath.row < quests!.count
        {
            choosenID = quests![indexPath.row]["id"]!
                performSegueWithIdentifier("QuestsToQuest",sender: self)
        }
    } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegueWithIdentifier("QuestsToPayment",sender: self)
            }
        }
    }
}