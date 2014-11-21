//
//  Original.swift
//  NightQuest
//
//  Created by Admin on 20.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit


class Original: UIViewController, iRiddle {//
    
    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        _riddle = ["":""]
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private var _riddle: [String:String]
    var riddle: [String:String] { get {return _riddle} set(newval){_riddle = newval} }
    
}