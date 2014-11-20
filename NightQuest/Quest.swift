//
//  Quest.swift
//  NightQuest
//
//  Created by Admin on 09.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

//
//  MyQuestsController.swift
//  NightQuest
//
//  Created by Admin on 09.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit

class Quest :UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    required init(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        myQuest = ["":""]
        super.init(coder:aDecoder)
        
        //self.tableView = QTable
    }
    var riddlesMain,riddlesExtra:[[String:String]]?
    var myQuest:[String:String]
    @IBOutlet weak var QTable: UITableView!
    
   // @IBOutlet weak var Description: UILabel!
    
    @IBOutlet weak var Name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //     // Do any additional setup after loading the view, typically from a nib.
        /* self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "QCell")*/
        //  Progress.startAnimating()
        // QTable.style = UITableViewStyle.
        Name.text = myQuest["name"]
        //Description.text = myQuest["description"]
        server.tryCheckLogin(loginChecked)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    var r = false
    var re = false
    func loginChecked(ok:Bool)
    {
        if ok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            server.tryGetRiddles(myQuest["id"]!,callback: OnRiddlesRecieved)
            server.tryGetExtraRiddles(myQuest["id"]!,callback: OnExtraRiddlesRecived)
        } else   {self.performSegueWithIdentifier("QuestToLogin",sender: self) }
    }
    func OnRiddlesRecieved(json:NSDictionary)
    {
        r = true
        if json["code"] as String == "ok" {
            
            riddlesMain = json["riddles"] as [[String:String]]?
        
            QTable.reloadData()
        } else {
            println("error getting main riddles")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = !(r&re)
    }
    func OnExtraRiddlesRecived(json:NSDictionary)
    {
        re = true
        if json["code"] as String == "ok" {
            
            riddlesExtra = json["riddles"] as [[String:String]]?
             QTable.reloadData()
        } else {
            println("error getting quests")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = !(re&r)
    }
    

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.riddlesMain != nil {
                return self.riddlesMain!.count
            } else {
                return 0
            }
        } else if section == 1 {
            if self.riddlesExtra != nil {
                return self.riddlesExtra!.count
            } else {
                return 0
            }
        }
        return 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = QTable.dequeueReusableCellWithIdentifier("QCell") as UITableViewCell
        if indexPath.section == 0 && riddlesMain != nil && indexPath.row < riddlesMain!.count
        {
            cell.textLabel.text = "Загадка #\(indexPath.row)"
            cell.detailTextLabel!.text =  "Почитать/ввести код"
        }
        
        if indexPath.section == 1 && riddlesExtra != nil && indexPath.row < riddlesExtra!.count
        {
            cell.textLabel.text = "Дополнительное задание #\(indexPath.row)"
            cell.detailTextLabel!.text =  "Почитать/ввести код"
            
        }
        //cell.textLabel.text = "123"
        return cell
    }
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Основное"
        } else if section == 1 {
            return "Дополнительное"
        }
        return nil
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var source:[[String:String]]? = nil
        switch (indexPath.section) {
        case 0...1:
            let src = (indexPath.section == 0) ? riddlesMain : riddlesExtra
            let riddle = src![indexPath.row]
            switch(riddle["type"]! as String) {
                case "1"://original
                    performSegueWithIdentifier("OriginalR",sender: self)
                    break;
                case "2"://photohunt
                    performSegueWithIdentifier("PhotohuntR",sender: self)
                    break
                case "3"://comefirst
                    performSegueWithIdentifier("ComefirstR",sender: self)
                    break;
                default:
                    notify("Неизвестный тип загадки -- обновите приложение.")
            }
            break
        default:
            println("unknown tap")
        }
    }
    func notify(errorMsg:String,title:String = "Ошибка")
    {
        let alert = UIAlertController(title: title, message: errorMsg, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: {
                (alert: UIAlertAction!) in return
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}