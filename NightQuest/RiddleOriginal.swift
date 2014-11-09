//
//  RiddleOriginal.swift
//  NightQuest
//
//  Created by Admin on 09.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit


class RiddleOriginalViewController: UIViewController {//контроллер главного окна проги
    
    var choosenRiddle:[String:String]?
    
    @IBOutlet weak var SubmitBtn: UIButton!
    
    @IBOutlet weak var Blurer: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //эта функция проверят правильный ли код
    //если правильный разблкирует вторую кнопку
    @IBAction func SendBtnPressed(sender: AnyObject) {
        if true {
            SubmitBtn.alpha = 1
            SubmitBtn.enabled = true
        }
    }
    //эта функция заставляет для сохранения кода сделать фотку
    @IBAction func SubmitBtnPressed(sender: AnyObject) {
    }
}