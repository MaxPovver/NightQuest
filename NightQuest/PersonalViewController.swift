//
//  PersonalViewController.swift
//  NightQuest
//
//  Created by Admin on 01.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class PersonalViewController: UIViewController {
    
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
    @IBAction func reset(sender :UIButton)//это делается при нажатии кнопки входа.
    {
        println("resetting pass")
        server.tryReset(processResetResult)
    }
    func processLogoutResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            println("Logout OK!")
        }
    }
    func processResetResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            println("Reset OK!")
        }
    }
}

