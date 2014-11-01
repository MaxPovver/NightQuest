//
//  ViewController.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
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
        var phoneNumber = self.username //вытаскиваем сюда значение телефона, который чувак зарегать хочет
        if phoneNumber.utf16Count > 5 {//если номер нормальной длины
            println("logging in as  \(self.username)")
            server.tryLogin(phoneNumber,pass: self.password,processLoginResult)
        }
        else
        {
            println("incorrect number \(self.username)")//здесь будет вывод сообщения "ваш номер слишком длинный" в айфоне
        }
    }
    func processLoginResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            println("Login OK!")
        }
    }
}

