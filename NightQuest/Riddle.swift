//
//  Riddle.swift
//  NightQuest
//
//  Created by Admin on 09.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation


class Riddle {
    private var id = 0
    private var order = 0
    private var code = ""
    private var description = ""
    private var type = 0
    private var verified = false
    private var raw:[String:String]
    private weak var my:Server?
    private var verifyCallback:(Bool)->Void
    init(data:[String:String]) {
        raw = data
        id = raw["id"]!.toInt()!
        description = raw["description"]!
        type = raw["type"]!.toInt()!
        order = raw["order"]!.toInt()!
        verifyCallback = {(Bool)->Void in return}
    }
    func link(s:Server)->Riddle {
        my = s
        return self
    }
    func tryVerify(callback:(Bool) -> Void) {
        if my == nil { callback(false) }
        verifyCallback = callback
        //my.tryCheckCode(code)
    }
    private func OnCheckDone(json:NSDictionary) {
        if json["code"] as String == "ok" {
            verifyCallback(true)
            return
        }
        verifyCallback(false)
    }
}