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
    private var phone:String=""
    private var loggedIn=false;
    init()
    {
        
    }
    private let defaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    func onLoad()//если юзер был залогинен, пытается загрузить его из файла(чтоб автоматически войти)
    {
        var tmp=NSUserDefaults.standardUserDefaults().stringForKey("token")
        //println(tmp)
        if(tmp != nil && !tmp!.isEmpty)
        {
            self.tryCheckLogin(tmp!,{(json:NSDictionary)->Void in var l=json["code"] as String=="ok"; if l {println("ok "+tmp!);self.setToken(tmp!)}else{self.unsetToken()}})
        } else {
            self.tryRegister("admin",{(NSDictionary)->Void in return })//"грязный хак" для убирания проблемы с регистрацией, если юзер уже зашел, не делаем его
        }
        var ph=NSUserDefaults.standardUserDefaults().stringForKey("phone")
        if ph != nil && !ph!.isEmpty {
            self.phone=ph!
        }
        
    }
    func getPhone()->String {
        return self.phone
    }
    func onQuit()//сохраняет токен в файл
    {
        NSUserDefaults.standardUserDefaults().setObject(token,forKey:"token")
        NSUserDefaults.standardUserDefaults().setObject(phone,forKey:"phone")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    private func setToken(newVal:String)
    {
        self.token=newVal
        NSUserDefaults.standardUserDefaults().setObject(token,forKey:"token")
        NSUserDefaults.standardUserDefaults().setObject(phone,forKey:"phone")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.loggedIn=true
    }
    private func unsetToken()
    {
        self.token=""
        NSUserDefaults.standardUserDefaults().setObject(token,forKey:"token")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.loggedIn=false
    }
    func isLoggedIn()->Bool{return self.loggedIn}
    func tryCheckLogin(temp:String,callback:(NSDictionary)->Void)
    {
        let checkData="{\"action\":\"checkmylogin\",\"token\":\"\(temp)\"}"
        tryAnyQuery(checkData, callback)
    }
    func tryCheckLogin(callback:(NSDictionary)->Void)
    {
        let checkData="{\"action\":\"checkmylogin\",\"token\":\"\(self.token)\"}"
        tryAnyQuery(checkData, callback)
    }
    func tryRegister(phone: NSString,callback:(NSDictionary)->Void)
    {
        let registerData="{\"action\":\"register\",\"username\":\"\(phone)\"}"
        tryAnyQuery(registerData, callback)
    }
    func tryBuy(questID: String,callback: NSDictionary -> Void)
    {
        let buyData="{\"action\":\"buy\",\"qid\":\"\(questID)\",\"token\":\"\(self.token)\"}"
        tryAnyQuery(buyData, callback)
    }
    func tryLogin(phone: NSString,pass: NSString,callback:(NSDictionary)->Void)
    {
        let loginData="{\"action\":\"login\",\"username\":\"\(phone)\",\"password\":\"\(pass)\"}"
        func eatIt(json:NSDictionary)//добавим доп логику для логина в виде сохранения токена
        {
            if json["code"] as String=="ok"
            {
                self.phone=phone
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
        let gqcountData="{\"action\":\"get\",\"what\":\"qcount\",\"token\":\"\(self.token)\"}"
        tryAnyQuery(gqcountData, callback)
    }
    func tryGetQuestsList(select:String, callback:(NSDictionary)->Void)
    {
        let qlData="{\"action\":\"get\",\"what\":\"quests\",\"select\":\"\(select)\",\"columns\":\"name,time,id\"}";//,\"token\":\"\(self.token)\"}"
        tryAnyQuery(qlData, callback)
    }
    func tryGetQuest(id: String,callback:(NSDictionary)->Void)
    {
        let qData="{\"action\":\"get\",\"what\":\"quest\",\"id\":\"\(id)\"}";//\"token\":\"\(self.token)\"}"
        tryAnyQuery(qData, callback)
    }
    func typeNameForID(id: String)->String { // переводит тип квеста в читабельное название, потом надо будет синхронихировать с сервером
       /* $types[0]="Неизвестный тип квеста";
        $types[1]="Оригинальный";
        $types[2]="Фотоохота";
        $types[3]="Отгадал загадку и приехал на адрес раньше всех";
        $types[4]="Классика";*/
        let allowed = ["1":"Оригинальный","2":"Фотоохота","3":"Отгадал загадку и приехал на адрес раньше всех","4":"Классика"]
        let tmp = allowed[id]
        if tmp != nil {
            return tmp!
        } else {
            return "Неизвестный тип"
        }
    }
    func tryAnyQuery(data:String,callback:(NSDictionary)->Void)//делаем публичной для возможности расширить класс не меняя его кода
    {
        let registerURL=(self.apiURL + data)
        let tmp = registerURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let encoded = tmp?.stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println(registerURL/*+"="+encoded!*/)
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