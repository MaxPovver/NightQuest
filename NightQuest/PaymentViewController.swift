//
//  PaymentViewController.swift
//  NightQuest
//
//  Created by Admin on 02.11.14.
//  Copyright (c) 2014 NightQuest. All rights reserved.
//


import UIKit


class PaymentViewController: UIViewController,UIWebViewDelegate {
    
    

    @IBOutlet weak var Browser: UIWebView!
    @IBOutlet weak var Progress: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var url =  NSURL(string:"http://midnightquest.ru/payment-mobile.html")!
       // var url =  NSURL(string:"http://midnightquest.ru/personal.html")!
        var request = NSURLRequest(URL: url)
        Browser.delegate = self //тут скорее всего утчека памяти
        Browser.loadRequest(request)
        //Browser.scalesPageToFit = true
      //  Browser.loadHTMLString("payment.html",baseURL: NSURL(string:"http://midnightquest/")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ReadyBtnPressed(sender: AnyObject) {
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        // Report the error inside the web view.
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}