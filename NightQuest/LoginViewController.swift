//
//  ViewController.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    //@IBOutlet weak var errorLabel: UILabel!
   // @IBOutlet weak var WaitNotifier: UIActivityIndicatorView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        login.delegate = self
        password.delegate = self
        phone.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login(sender :AnyObject)//это делается при нажатии кнопки входа.
    {
        var phoneNumber = "+7" + self.login.text //вытаскиваем сюда значение телефона, который чувак зарегать хочет
            println("logging in as  \(phoneNumber)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            server.tryLogin(phoneNumber,pass: self.password.text,processLoginResult)
    }
    func processLoginResult(json:NSDictionary)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (json["code"] as String != "ok" ){
            self.notifyError(json["message"]? as String)
        } else
        {
            self.performSegueWithIdentifier("LoginToPersonal", sender: self)
            println("Login OK!")
        }
    }
    @IBAction func register(sender :AnyObject)//это делается при нажатии кнопки регистрацции.
    {
        var phoneNumber = "+7" + self.phone.text //вытаскиваем сюда значение телефона, который чувак зарегать хочет
        if phoneNumber.utf16Count == 12 {//если номер нормальной длины
            println("registering  \(phoneNumber)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            server.tryRegister(phoneNumber,processRegistrationResult)
        }
        else
        {
            self.notifyError("Некорректный номер телефона \(phoneNumber)")//здесь будет вывод сообщения "ваш номер слишком длинный" в айфоне
        }
    }
    func processRegistrationResult(json:NSDictionary)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (json["code"] as String != "ok" ){
            self.notifyError(json["message"] as String)
        } else
        {
            self.login.text = self.phone.text
            self.phone.text = ""
            self.password.becomeFirstResponder()
            println("Register OK. Wait for SMS with code")
        }
    }
    func notifyError(errorMsg:String)
    {
        let alert = UIAlertController(title: "Ошибка", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {
                (alert: UIAlertAction!) in return
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        if textField == login {
            password.becomeFirstResponder()
            
        }
        if textField == password {
            self.login(self)
        }
        if textField == phone {
            self.register(self)
        }
        return true;
    }
}

