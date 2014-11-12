//
//  ViewController.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
     //   server.onLoad()
        super.init(coder:aDecoder)
        ChooseBackgrounds()
    }
    
    
    //@IBOutlet weak var errorLabel: UILabel!
   // @IBOutlet weak var WaitNotifier: UIActivityIndicatorView!
   /* @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!*/
    private var login_pic,reg_pic:UIImage?
    
    @IBOutlet weak var bgrPic: UIImageView!
    @IBOutlet weak var Login: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Progress: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // server.tryCheckLogin(AccountOpen)
        server.tryCheckLogin(AccountOpen)
        Login.delegate =  self 
        Password.delegate = self
        Phone.delegate = self
        ToLogin(self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ChooseBackgrounds() {
        var reg_pic_name = "Reg@iPhone5"
        var login_pic_name = "Login@iPhone5"
       login_pic = UIImage(named: login_pic_name)
        reg_pic = UIImage(named: reg_pic_name)
    }
    @IBAction func ToReg(sender: AnyObject) {
        bgrPic.image =  reg_pic
        Login.hidden = true
        Password.hidden = true
        Phone.hidden = false
    }
    @IBAction func ToLogin(sender: AnyObject) {
        bgrPic.image = login_pic
        Phone.hidden = true
        Login.hidden = false
        Password.hidden = false
    }
    
  /*  @IBAction func test(sender: AnyObject) {
        println("123")
    }
    @IBAction func Tapped(sender: AnyObject) {
        self.becomeFirstResponder()
        println("tapped")
    }*/
    func isNum(s:String)->Bool {
        var f = NSNumberFormatter()
        var test = f.numberFromString(s)
        return test != nil
    }
    func convertPhone(phone:String)->String {

        if   !isNum(phone) {//если это не номер
            return phone//просто вернем как есть
        }
        println(phone.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        switch ( phone.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) )
        {
            case 10://9150000000 - прибавим +7
                    return  "+7\(phone)"
            case 11:// 89150000000 или 79150000000
                var newPh = phone.substringFromIndex(phone.startIndex.successor())//просто вырежем первую цифру и сведем к первому варианту
                return "+7\(newPh)"
            case 12://+79153832915
                return phone//просто вернем
        default://рандомный набор цифр
            return phone//просто вернем
        }
    }
   @IBAction func login(sender :AnyObject)//это делается при нажатии кнопки входа.
    {
        var phoneNumber = convertPhone(self.Login.text) //вытаскиваем сюда значение телефона, который чувак зарегать хочет
            println("logging in as  \(phoneNumber)")
        Progress.startAnimating()
            server.tryLogin(phoneNumber,pass: self.Password.text,processLoginResult)
    }
    func processLoginResult(json:NSDictionary)
    {
        Progress.stopAnimating()
        if (json["code"] as String != "ok" ){
            self.notify(json["message"]? as String)
        } else
        {
            self.performSegueWithIdentifier("LoginToMain", sender: self)
            println("Login OK!")
        }
    }
    func AccountOpen(loggedIn:Bool) {
        if loggedIn {
            self.performSegueWithIdentifier("LoginToMain",sender:self)
        } else if !server.getPhone().isEmpty { Login.text = server.getPhone() }
    }
    @IBAction func register(sender :AnyObject)//это делается при нажатии кнопки регистрацции.
    {
        var phoneNumber = convertPhone( self.Phone.text ) //вытаскиваем сюда значение телефона, который чувак зарегать хочет
        if phoneNumber.utf16Count == 12 {//если номер нормальной длины
            println("registering  \(phoneNumber)")
            Progress.startAnimating()
            server.tryRegister(phoneNumber,processRegistrationResult)
        }
        else
        {
            self.notify("Некорректный номер телефона \(phoneNumber)")//здесь будет вывод сообщения "ваш номер слишком длинный" в айфоне
        }
    }
    func processRegistrationResult(json:NSDictionary)
    {
        Progress.stopAnimating()
        if (json["code"] as String != "ok" ){
            self.notify(json["message"] as String)
        } else
        {
            self.Login.text = self.Phone.text
            self.Phone.text = ""
            self.Password.becomeFirstResponder()
            ToLogin(self)
            notify("Пароль выслан вам по СМС. Ожидайте.",title:"Информация")
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
   func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
   {
        //println("...")
        textField.resignFirstResponder()
        if textField == Login {
            Password.becomeFirstResponder()
        }
        if textField == Password {
            self.login(self)
        }
        if textField == Phone {
            self.register(self)
        }
        return true;
    }
}

