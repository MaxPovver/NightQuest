//
//  Photohunt.swift
//  NightQuest
//
//  Created by Admin on 20.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//

import Foundation

import UIKit


class Photohunt: UIViewController, UITableViewDelegate, UITableViewDataSource, iRiddle, UITextFieldDelegate  {//

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        _riddle = ["":""]
        super.init(coder: aDecoder)
    }
    
    
    @IBOutlet weak var Hint: UILabel!
    @IBOutlet weak var Picture: UIWebView!
    @IBOutlet weak var Codes: UITableView!
    private var _riddle: [String:String]
    var riddle: [String:String] { get {return _riddle} set(newval){_riddle = newval} }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        if !riddle.isEmpty {
            //println()
            /*let src = server.riddlePicHtml(riddle["id"]!)
            print(src)*/
           // Picture.loadRequest(NSURLRequest( URL:NSURL(string:src)! ) )
            Picture.loadHTMLString(server.riddlePicHtml(riddle["id"]!), baseURL: nil)
            let r = riddle["radius"]!
            Hint.text = "Коды нахоятся на расстоянии не больше \(r) м от места фото"
          /* NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);*/
        }
    }
    deinit {
       // NSNotificationCenter.defaultCenter().removeObserver(self);
    }
   /* func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.topConstraint.constant = keyboardFrame.size.height - 20
         //   self.bottomConstraint.constant = keyboardFrame.size.height - 20
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.topConstraint.constant = keyboardFrame.size.height + 20
           // self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Ready(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1//4
    }
/*    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "OriginalR" || segue.identifier == "PhotohuntR" || segue.identifier == "ComefirstR" {
            
            //segue.destinationViewController.parentViewController  = self
        }
        println("wtf")
    }*/
    
     func tableView(tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 3 }
        return 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = Codes.dequeueReusableCellWithIdentifier("CodeCell") as UITableViewCell
        
        return cell
    }
     func titleForHeaderInSection(tableView: UITableView,  section: Int) -> String? {
        return nil
    }
     func didSelectRowAtIndexPath(tableView: UITableView,  indexPath: NSIndexPath) {
        // все равно тут ничего не делается - наступление квеста авоматически проверяется
    }
    override func supportedInterfaceOrientations() -> Int {// чтоб не поворачивли на бок
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    /*func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }*/
}