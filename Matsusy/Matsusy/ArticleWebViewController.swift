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

class ArticleWebViewController: UIViewController, WKNavigationDelegate{
    
    var shareView = UIView()
    var myArticle = ArticleStocks.sharedInstance
    var article: Article!
    var wkWebView:WKWebView!
    
    let backgroundView = UIView()
    let actionMenuHeight:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var URL = NSURL(string: article.link)
        var URLReq = NSURLRequest(URL: URL!)
        self.wkWebView = WKWebView(frame: self.view.frame)
        self.wkWebView.loadRequest(URLReq)
        self.wkWebView.navigationDelegate = self
        self.view.addSubview(wkWebView)

        //ナビゲーションバーのタイトル、ボタン
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showActionMenu")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HirakakuProN-W3", size: 15)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //ナビゲーションバー表示
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showActionMenu(){
        setBackgroundView()
        setShareView()
        let pointX = self.view.frame.width/8
        let btnNames = ["facebook_icon", "twitter_icon", "safari_icon", "book1"]
        for index in 1...4 {
            println(pointX*CGFloat(2*index-1))
            setShareBtn(pointX*CGFloat(2*index-1), y: 50, tag: index, imageName: btnNames[index-1] )
        }
        
        //アニメーション
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.frame.origin = CGPointMake(0, self.view.frame.height - self.actionMenuHeight)
        })
        
    }
    
    
    func setBackgroundView() {
        println(self.view.frame)
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPointMake(0, 0)
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
        shareView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, actionMenuHeight)
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    }
    
    func setShareBtn(x: CGFloat, y: CGFloat, tag: Int, imageName: String){
        var shareBtn = UIButton()
        shareBtn.frame.size = CGSizeMake(60, 60)
        shareBtn.center = CGPointMake(x, y)
        shareBtn.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: "tapSharebtn:", forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    
    func tapSharebtn(sender: UIButton){
        if sender.tag == 1 {
            var facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookVC.setInitialText(wkWebView.URL?.absoluteString)
            presentViewController(facebookVC, animated: true, completion: nil)
        } else if sender.tag == 2 {
            var twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterVC.setInitialText(wkWebView.URL?.absoluteString)
            presentViewController(twitterVC, animated: true, completion: nil)
        } else if sender.tag == 3 {
            println(wkWebView.URL!)
            UIApplication.sharedApplication().openURL(wkWebView.URL!)
        } else if sender.tag == 4 {
            if self.isStockedArticle() {
                self.alert("登録済みです。")
            } else {
                myArticle.addArticleStocks(article)
                self.alert("ブックマークに追加しました。")
            }
        }
    }

    
    //bookmark使用とした記事がすでにマークいているか否かでBOOL
    func isStockedArticle() -> Bool {
        for article in myArticle.myArticles {
            if article.link == self.article.link {
                return true
            }
        }
        return false
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.title = "読み込み中..."
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.title = self.wkWebView.title
    }
    
    
    func alert(text: String){
        let alertController = UIAlertController(title: "じゅんじゅん！", message:"ゴール！" , preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.backgroundView.removeFromSuperview()
        }
        alertController.addAction(action)
        var hogan = NSMutableAttributedString(string: text)
        hogan.addAttribute(NSFontAttributeName, value: UIFont(name: "HirakakuProN-W3", size: 15)!, range: NSRange(location: 0, length: hogan.length))
        alertController.setValue(hogan, forKey: "attributedTitle")
        self.presentViewController(alertController, animated: true, completion: nil)
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
