//
//  PersonalViewController.swift
//  NightQuest
//
//  Created by Admin on 01.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class PersonalViewController: UIViewController {
    
    @IBOutlet weak var Progress: UIActivityIndicatorView!
    @IBOutlet weak var QuestsCounter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logout(sender :UIButton)//это делается при нажатии кнопки входа.
    {
        println("logging out")
        server.tryLogout(processLogoutResult)
    }
    func processLogoutResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            self.performSegueWithIdentifier("PersonalToLogin", sender: self)
            println("Logout OK!")
        }
    }
    
    @IBAction func reset(sender :UIButton)//это делается при нажатии кнопки входа.
    {
        println("resetting pass")
        server.tryReset(processResetResult)
    }
    func processResetResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            self.performSegueWithIdentifier("PersonalToLogin", sender: self)
            println("Reset OK!")
        }
    }
    
    @IBAction func reloadQuestCount(sender :UIButton)//обновить кол-во оплаченных квестов
    {
        println("loading quests count")
        Progress.startAnimating()
        server.tryGetQCount(processResult)
    }
    func processResult(json: NSDictionary){
        Progress.stopAnimating()
        if(json["code"] as String=="ok")
        {
            QuestsCounter.text = (json["message"] as String)
        } else {
             self.performSegueWithIdentifier("PersonalToLogin", sender: self)
            println("Impossible to get quests count, logging out...")
        }
    }
}

