//
//  QuestView.swift
//  NightQuest
//
//  Created by Admin on 05.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//


import UIKit


class QuestViewController: UIViewController {
    var myID=""
    @IBOutlet weak var QName: UILabel!
    @IBOutlet weak var QDescription: UILabel!
    @IBOutlet weak var QTime: UILabel!
    @IBOutlet weak var QLength: UILabel!
    @IBOutlet weak var ErrorNotify: UILabel!
    @IBOutlet weak var Progress: UIActivityIndicatorView!
    @IBOutlet weak var QType: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Progress.startAnimating()
        server.tryGetQuest(myID,OnQuestRecived)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func OnQuestRecived(json:NSDictionary) {
        Progress.stopAnimating()
        if json["code"] as String == "ok" {
            var err:NSError?
            let jsonObject = NSJSONSerialization.JSONObjectWithData(
                (json["quest"] as String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,
                options: NSJSONReadingOptions.MutableContainers, error: &err)
            let quest = jsonObject as [String:String]
            QName.text = quest["name"]
            QDescription.text = quest["description"]
            QTime.text = quest["time"]
            QLength.text = quest["length"]
            QType.text = server.typeNameForID(quest["type"]!)
        } else {
            ErrorNotify.text = "Не удалось загрузить квест!"
        }
    }
    /*алгоритм проверок такой: 1) залогинен? 2) уже купил этот квест? 3) достаточно денег?*/
    @IBAction func BuyBtnPressed(sender: AnyObject) {
        Progress.startAnimating()
        server.tryCheckLogin( OnLoginChecked)//проверим логин
    }
    func OnLoginChecked(json:NSDictionary)
    {
        if json["code"] as String != "ok" {//если не залогинен, сообщим об этом
            Progress.stopAnimating()//и покажем, что операций больше не выполняется
            ErrorNotify.text = "Войдите, чтобы делать покупки"
        } else {//иначе попытаемся купить
            server.tryBuy(myID,OnBuy)
        }
    }
    func OnBuy(json:NSDictionary) {
          Progress.stopAnimating()
        if json["code"] as String == "ok" {//если покупка удалась
            performSegueWithIdentifier("QuestToQuests", sender: self)//вернемся обратно в список квестов
        } else {
            ErrorNotify.text = json["message"] as String//иначе вывдем сообщение сервера о причине, по которой покупка не получится
         }
    }
}