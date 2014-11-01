//
//  ViewController.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var phone = ""
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
    
    @IBAction func phoneEdited(sender :UITextField)
    {
        self.phone = sender.text //при каждом редактировании сохараняем в нашу переменную новое значение поля
    }
    @IBAction func unameEdited(sender :UITextField)
    {
        self.username = sender.text //при каждом редактировании сохараняем в нашу переменную новое значение поля
    }
    @IBAction func passEdited(sender :UITextField)
    {
        self.password = sender.text //при каждом редактировании сохараняем в нашу переменную новое значение поля
    }
    @IBAction func register(sender :UIButton)//это делается при нажатии кнопки регистрацции.
    {
        var phoneNumber = self.phone //вытаскиваем сюда значение телефона, который чувак зарегать хочет
        if phoneNumber.utf16Count > 5 {//если номер нормальной длины
            println("registering  \(self.phone)")
            server.tryRegister(phoneNumber,processRegistrationResult)
        }
        else
        {
            println("incorrect number \(self.phone)")//здесь будет вывод сообщения "ваш номер слишком длинный" в айфоне
        }
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
    func processRegistrationResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"] as String)
        } else
        {
            println("Register OK. Wait for SMS with code")
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

