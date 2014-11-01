//
//  RegisterViewController.swift
//  NightQuest
//
//  Created by Admin on 01.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    
    var phone = ""
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
    func processRegistrationResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"] as String)
        } else
        {
            println("Register OK. Wait for SMS with code")
        }
    }
}

