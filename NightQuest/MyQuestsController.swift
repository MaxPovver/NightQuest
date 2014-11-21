//
//  MyQuestsController.swift
//  NightQuest
//
//  Created by Admin on 09.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit

class MyQuestsController :UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    required init(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)

    }
    var l1 = false
    var l2 = false
    var l3 = false
    var left = false
    /*required init(style:)
    {*/
    //var quets = ["We", "Heart", "Swift"]
    var questsNew,questsNow,questsOld:[[String:String]]?
    var choosenQuest:[String:String]?
    
    @IBOutlet weak var QTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //     // Do any additional setup after loading the view, typically from a nib.
        /* self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "QCell")*/
        //  Progress.startAnimating()
        // QTable.style = UITableViewStyle.
       //а вдруг уже квест идет? тогда сразу кидаем на его страничку
    server.tryCheckLogin(loginChecked)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "MQToPlay" ) {
            left = true
            let vc = (((segue.destinationViewController as UITabBarController).viewControllers![0] as UINavigationController).viewControllers![0] as Quest)
            vc.myQuest = choosenQuest!
        }
        
    }
    func loginChecked(ok:Bool)
    {
       // presentViewController
        if ok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            l1 = false
            l2 = false
            l3 = false
            server.tryGetMyQuestsList("new",callback: OnNewQListRecived)
            server.tryGetMyQuestsList("now",callback: OnNowQListRecived)
            server.tryGetMyQuestsList("old",callback: OnOldQListRecived)
        } else   {self.performSegueWithIdentifier("MQuestsToLogin",sender: self) }
    }
    func OnNewQListRecived(json:NSDictionary)
    {
        
        if json["code"] as String == "ok" {
            l1 = true
            questsNew = json["quests"] as [[String:String]]?
            //if l1&&l2&&l3
                QTable.reloadData()
        } else {
            println("error getting quests")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = !(l1&&l2&&l3)
    }
    func OnNowQListRecived(json:NSDictionary)
    {
        if json["code"] as String == "ok" {
            l2 = true
            questsNow = json["quests"] as [[String:String]]?
           // if l1&l2&l3
            QTable.reloadData()
        } else {
            println("error getting quests")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = !(l1&&l2&&l3)
    }
    func OnOldQListRecived(json:NSDictionary)
    {
        if json["code"] as String == "ok" {
            l3 = true
            questsOld = json["quests"] as [[String:String]]?
            //if l1&l2&l3
            QTable.reloadData()
        } else {
            println("error getting quests")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = !(l1&&l2&&l3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3//4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.questsNew != nil {
                return self.questsNew!.count
            } else {
                return 0
            }
        } else if section == 1 {
            if self.questsNow != nil {//при каждом обновлении данных
                //если есть квесты, идущие сейчас
                //оправим на вьюху выполнения квеста
                choosenQuest = questsNow![0]
                if !left {performSegueWithIdentifier("MQToPlay",sender: self)}
                return self.questsNow!.count
            } else {
                return 0
            }
        } else if section == 2 {
            if self.questsOld != nil {
                return self.questsOld!.count
            } else {
                return 0
            }
        } /*else if section == 3
        {
            return 1
        }*/
        return 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("QCell") as UITableViewCell
        if indexPath.section == 0 && questsNew != nil && indexPath.row < questsNew!.count
            {
                cell.textLabel.text = questsNew![indexPath.row]["name"]!
                cell.detailTextLabel!.text =  questsNew![indexPath.row]["time"]!
            }
        
        if indexPath.section == 1 && questsNow != nil && indexPath.row < questsNow!.count
        {
                cell.textLabel.text = questsNow![indexPath.row]["name"]!
                cell.detailTextLabel!.text =  questsNow![indexPath.row]["time"]!
    
        }
        if indexPath.section == 2 && questsOld != nil && indexPath.row < questsOld!.count
            {
                cell.textLabel.text = questsOld![indexPath.row]["name"]!
                cell.detailTextLabel!.text =  questsOld![indexPath.row]["time"]!
            }
       /* if questsNew != nil || questsNow != nil || questsOld != nil {
            if indexPath.section == 3 {
                if indexPath.row == 0 {
                    cell.textLabel.text = "Купить квесты"
                    cell.detailTextLabel!.text = ""
                }
            }
        }*/
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Еще не наступили"
        } else if section == 1 {
                return "Идет сейчас"
            } else if section == 2 {
                    return "Уже прошли"
              /*  } else if section == 3 {
            return "Действия"*/
        }
        return nil
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          // все равно тут ничего не делается - наступление квеста авоматически проверяется
        
    }
}