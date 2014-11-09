//
//  MainViewController.swift
//  NightQuest
//
//  Created by Admin on 01.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {//контроллер главного окна проги
    
    var choosenQuest:[String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func AccountOpen(sender: AnyObject) {
        if server.isLoggedIn() {
            self.performSegueWithIdentifier("MainToPersonal",sender:self)
        } else {
            self.performSegueWithIdentifier("MainToLogin",sender:self)
        }
    }
    @IBAction func PlayPressed(sender: AnyObject) {
         server.tryCheckQuestNow(OnQNCheck)
    }
    func OnQNCheck(json:NSDictionary)
    {
        if json["code"] as String == "ok" {
            if json["message"] as String == "yes" //только если юзер уже имеет реальный квест
            {
                choosenQuest = json["current"] as [String:String]
                performSegueWithIdentifier("MainToPlay", sender: self)
            }
        }else  {performSegueWithIdentifier("MainToMyQuests", sender: self)}
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "MainToPlay") {
            let vc = segue.destinationViewController as Quest
            vc.myQuest = choosenQuest!
        }
    }
}