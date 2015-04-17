//
//  ArticleWebViewController.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit
import WebKit
import Social

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var url:String?
    var wkWebView:WKWebView!
    let backgroundView = UIView()
    var shareView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.wkWebView = WKWebView(frame: self.view.frame)
        var URL = NSURL(string: url!)
        var URLReq = NSURLRequest(URL: URL!)
        self.wkWebView.loadRequest(URLReq)
        self.view.addSubview(wkWebView)
        
        self.wkWebView?.navigationDelegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "menu", style: UIBarButtonItemStyle.Plain, target: self, action: "menu")
    }
    
    func menu(){
        setbackgroundView()
        setShareView()
        setShareBtn(40, y: 40, tag: 1)
        setShareBtn(160, y: 40, tag: 2)
        setShareBtn(40, y: 160, tag: 3)
        setShareBtn(160, y: 160, tag: 4)
    }
    
    func setbackgroundView() {
        backgroundView.frame = self.view.frame
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapBackgroundView")
        backgroundView.addGestureRecognizer(gesture)
    }
    
    func tapBackgroundView(){
        backgroundView.removeFromSuperview()
    }
    
    func setShareView(){
        //サイズを決めた後に位置を設定してあげ.サイズを設定していないとviewは点になる
        shareView.frame.size = CGSizeMake(300, 300)
        shareView.center = backgroundView.center
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    }
    
    func setShareBtn(x: CGFloat, y: CGFloat, tag: Int){
        var shareBtn = UIButton(frame: CGRectMake(x, y, 100, 100))
        shareBtn.setTitle("T", forState: UIControlState.Normal)
        shareBtn.backgroundColor = UIColor.blueColor()
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: "tapSharebtn:", forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    func tapSharebtn(sender: UIButton){
        if sender.tag == 1 {
            var twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterVC.setInitialText(wkWebView.URL?.absoluteString)
            presentViewController(twitterVC, animated: true, completion: nil)
        } else if sender.tag == 2 {
            var facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookVC.setInitialText(wkWebView.URL?.absoluteString)
            presentViewController(facebookVC, animated: true, completion: nil)
        } else if sender.tag == 3 {
            println("==================")
            println(wkWebView.URL!)
            UIApplication.sharedApplication().openURL(wkWebView.URL!)
        } else if sender.tag == 4 {
            println("マイリストに保存！")
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.title = "読み込み中..."
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.title = self.wkWebView.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
