//
//  ServerCooperation.swift
//  NightQuest
//
//  Created by Admin on 30.10.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

// класс для всего общения с сервером и кеширования
//работает как источник данных приложения
class Server {
    let apiURL="http://nightquest-pro.1gb.ru/mobile/api.php?q=" //адрес для запросов к "апи", к нему надо просто прибавить JSON в виде строки
    var token=""
    func tryRegister(phone: NSString)
    {
        let registerData="{\"action\":\"register\",\"username\":\"\(phone)\"}"
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
            // println(jsonResult["message"])
            dispatch_async(dispatch_get_main_queue(), {
                self.processRegistrationResult(jsonResult)
            })
        })
        task.resume()
    }
    func tryLogin(phone: NSString,pass: NSString)
    {
        let registerData="{\"action\":\"login\",\"username\":\"\(phone)\",\"password\":\"\(pass)\"}"
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
            // println(jsonResult["message"])
            dispatch_async(dispatch_get_main_queue(), {
                self.processLoginResult(jsonResult)
            })
        })
        task.resume()
    }
    
    func tryLogout()
    {
        let registerData="{\"action\":\"logout\",\"token\":\"\(self.token)\"}"
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
                self.processLogoutResult(jsonResult)
            })
        })
        task.resume()
    }
    func tryReset()
    {
        let registerData="{\"action\":\"reset\",\"token\":\"\(self.token)\"}"
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
                self.processResetResult(jsonResult)
            })
        })
        task.resume()
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
            println("Login OK! Token "+(json["token"] as String))
            self.token=json["token"] as String
        }
    }
    func processLogoutResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            println("Logout OK!")
            self.token=""
        }
    }
    func processResetResult(json:NSDictionary)
    {
        if (json["code"] as String != "ok" ){
            println(json["message"]? as String)
        } else
        {
            println("Reset OK!")
            self.token=""
        }
    }}