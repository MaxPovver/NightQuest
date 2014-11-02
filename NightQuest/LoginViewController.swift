//
//  ViewController.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var WaitNotifier: UIActivityIndicatorView!
    var username = ""
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unameEdited(sender :UITextField)
    {
        self.username = sender.text //при каждом редактировании сохараняем в нашу переменную новое значение поля
    }
    @IBAction func passEdited(sender :UITextField)
    {
        self.password = sender.text //при каждом редактировании сохараняем в нашу переменную новое значение поля
    }
    @IBAction func login(sender :UIButton)//это делается при нажатии кнопки входа.
    {
        var phoneNumber = "+7" + self.username //вытаскиваем сюда значение телефона, который чувак зарегать хочет
            println("logging in as  \(phoneNumber)")
        WaitNotifier.startAnimating()
            server.tryLogin(phoneNumber,pass: self.password,processLoginResult)
    }
    func processLoginResult(json:NSDictionary)
    {
        WaitNotifier.stopAnimating()
        if (json["code"] as String != "ok" ){
            self.notifyError(json["message"]? as String)
        } else
        {
            self.performSegueWithIdentifier("LoginToPersonal", sender: self)
            println("Login OK!")
        }
    }
    func notifyError(errorMsg:String)
    {
        self.errorLabel.text=errorMsg
    }
}

