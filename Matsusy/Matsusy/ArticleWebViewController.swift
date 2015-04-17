//
//  ArticleWebViewController.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var url:String?
    var wkWebView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("ユーアルエル！\(url)")

        self.wkWebView = WKWebView(frame: self.view.frame)
        var URL = NSURL(string: url!)
        var URLReq = NSURLRequest(URL: URL!)
        self.wkWebView.loadRequest(URLReq)
        self.view.addSubview(wkWebView)
        
        self.wkWebView?.navigationDelegate = self
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
