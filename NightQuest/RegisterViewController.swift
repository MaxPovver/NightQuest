//
//  RegisterViewController.swift
//  NightQuest
//
//  Created by Admin on 01.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var regErrorLabel: UILabel!
    @IBOutlet weak var WaitNotifier: UIActivityIndicatorView!
    @IBOutlet weak var ToLogin: UIButton!
    
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
        var phoneNumber = "+7" + self.phone //вытаскиваем сюда значение телефона, который чувак зарегать хочет
        if phoneNumber.utf16Count == 12 {//если номер нормальной длины
            println("registering  \(self.phone)")
            WaitNotifier.startAnimating()
            server.tryRegister(phoneNumber,processRegistrationResult)
        }
        else
        {
            self.notifyError("Некорректный номер телефона +7\(self.phone)")//здесь будет вывод сообщения "ваш номер слишком длинный" в айфоне
        }
    }
    func processRegistrationResult(json:NSDictionary)
    {
         WaitNotifier.stopAnimating()
        if (json["code"] as String != "ok" ){
            self.notifyError(json["message"] as String)
        } else
        {
            self.performSegueWithIdentifier("RegisterToLogin", sender: self)
            println("Register OK. Wait for SMS with code")
        }
    }
    func notifyError(errormsg: String)
    {
        regErrorLabel.text=errormsg;
    }
}

