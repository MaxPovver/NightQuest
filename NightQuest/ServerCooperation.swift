//
//  ServerCooperation.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation
import UIKit

// класс для всего общения с сервером и кеширования
//работает как источник данных приложения
class Server {
    let apiURL="http://midnightquest.ru/mobile/api.php?q=" //адрес для запросов к "апи", к нему надо просто прибавить JSON в виде строки
   // let savefile="settings-private.dat"
    
    private var token:String=""
    private var loggedIn=false;
    init()
    {
        
    }
    private let defaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    func onLoad()//если юзер был залогинен, пытается загрузить его из файла(чтоб автоматически войти)
    {
        var tmp=defaults.stringForKey("token")
        if(tmp != nil)
        {
            token=tmp!
        }
        self.tryRegister("admin",{(NSDictionary)->Void in return })//"грязный хак" для убирания проблемы с регистрацией
        
    }
    func onQuit()//сохраняет токен в файл
    {
        defaults.setObject(token,forKey:"token")
        defaults.synchronize()
    }
    private func setToken(newVal:String)
    {
        self.token=newVal
        self.loggedIn=true
    }
    private func unsetToken()
    {
        self.token=""
        self.loggedIn=false
    }
    func isLoggedIn()->Bool{return self.loggedIn}
    func tryRegister(phone: NSString,callback:(NSDictionary)->Void)
    {
        let registerData="{\"action\":\"register\",\"username\":\"\(phone)\"}"
        tryAnyQuery(registerData, callback)
    }
    func tryLogin(phone: NSString,pass: NSString,callback:(NSDictionary)->Void)
    {
        let loginData="{\"action\":\"login\",\"username\":\"\(phone)\",\"password\":\"\(pass)\"}"
        func eatIt(json:NSDictionary)//добавим доп логику для логина в виде сохранения токена
        {
            if json["code"] as String=="ok"
            {
                self.setToken(json["token"] as String)
            }
            callback(json)
        }
        tryAnyQuery(loginData, eatIt)//для логин помимо стандартного сообщения нам нужно сохранить токен, после чего вызываем обработчик вызвывашего нас
    }
    
    func tryLogout(callback:(NSDictionary)->Void)
    {
        let logoutData="{\"action\":\"logout\",\"token\":\"\(self.token)\"}"
        func eatIt(json:NSDictionary)//добавим доп логику для логаута в виде удаления бесполезных данных
        {
            if json["code"] as String=="ok"
            {
                self.unsetToken()
            }
            callback(json)
        }
        tryAnyQuery(logoutData, eatIt)
    }
    func tryReset(callback:(NSDictionary)->Void)
    {
        let resetData="{\"action\":\"reset\",\"token\":\"\(self.token)\"}"
        tryAnyQuery(resetData, callback)
    }
    func tryGetQCount(callback:(NSDictionary)->Void)
    {
        let gqcountData="{\"action\":\"getqcount\",\"token\":\"\(self.token)\"}"
        tryAnyQuery(gqcountData, callback)
    }
    func tryAnyQuery(data:String,callback:(NSDictionary)->Void)//делаем публичной для возможность раширить класс не меняя его кода
    {
        let registerData=data;
        let registerURL=(self.apiURL + registerData)
        let tmp = registerURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let encoded = tmp?.stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println(registerURL+"="+encoded!)
        var url: NSURL = NSURL(string: encoded!)!
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err? != nil) {
                println(error.localizedDescription)
            }
            dispatch_async(dispatch_get_main_queue(), {
                callback(jsonResult)
            })
        })
        task.resume()
    }
}