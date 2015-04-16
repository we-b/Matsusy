//
//  ArticleViewController.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var articleScrollView: UIScrollView!
    @IBOutlet weak var headerUnderber: UIView!
    
    let wiredXML = "http://wired.jp/rssfeeder/"
    let shikiXML =  "http://www.100shiki.com/feed"
    let cinraXML =   "http://www.cinra.net/rss-all.xml"
    
    var articles:Array<Article> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //ヘッダー
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.headerUnderber.backgroundColor = UIColor.redColor()
        
        //scrollView
        self.articleScrollView.delegate = self
        self.articleScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: articleScrollView.frame.height)
        self.articleScrollView.pagingEnabled = true
        
        //site top image
        setSiteTopImage(0, imageName: "wired_top_image")
        setSiteTopImage(self.view.frame.width, imageName: "wsj_top_image")
        setSiteTopImage(self.view.frame.width*2, imageName: "100shiki_top_image")
        
        //table view
        setArticleTableView(0, siteXML: wiredXML, tag: 1)
        setArticleTableView(self.view.frame.width, siteXML: shikiXML, tag: 2)
        setArticleTableView(self.view.frame.width*2, siteXML: cinraXML, tag: 3)
        
        //tabLable
        setTabLabel(10, text: "WIRED")
        setTabLabel(130, text: "WSJ")
        setTabLabel(250, text: "100shiki")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setArticleTableView(x: CGFloat, siteXML: String, tag: Int){
        var frame = CGRectMake(x, 200, self.view.frame.width, articleScrollView.frame.height - 200)
        var articleTableView = ArticleTableView(frame: frame)
        articleScrollView.tag = tag
        articleTableView.loadRSS(siteXML, articleArray: articles)
        articleScrollView.addSubview(articleTableView)
    }
    
    func setTabLabel(x: CGFloat, text: String){
        var tabLabel = UILabel(frame: CGRectMake(x, 33, 110, 64-30))
        tabLabel.text = text
        tabLabel.textColor = UIColor.whiteColor()
        tabLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        tabLabel.backgroundColor = UIColor.redColor()
        tabLabel.textAlignment = NSTextAlignment.Center
        tabLabel.layer.cornerRadius = 3
        tabLabel.layer.masksToBounds = true
        self.headerView.addSubview(tabLabel)
    }
    
    func setSiteTopImage(x: CGFloat, imageName: String){
        let siteTopImageView = UIImageView(frame: CGRectMake(x, 0, self.view.frame.width, 200))
        siteTopImageView.image = UIImage(named: imageName)
        siteTopImageView.contentMode = UIViewContentMode.ScaleAspectFill
        siteTopImageView.layer.masksToBounds = true
        articleScrollView.addSubview(siteTopImageView)
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollPoint = articleScrollView.contentOffset.x
        println("スクロール位置\(scrollPoint)")
        if scrollPoint < CGFloat(375) {
            headerUnderber.backgroundColor = UIColor.redColor()
        } else if scrollPoint < CGFloat(750) {
            headerUnderber.backgroundColor = UIColor.blueColor()
        } else {
            headerUnderber.backgroundColor = UIColor.greenColor()
        }
    }
    

    func segeToWeb(articleURL: AnyObject){
        println("幸せ！")
        println(articleURL)
        self.performSegueWithIdentifier("articleSegue", sender: articleURL)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("aaaaaaaaaaaaaaaaaaa")
        if segue.identifier == "articleSegue" {
            println("oooooooooooooooo")
            var articleURL = sender as String
            var articleWebViewController: ArticleWebViewController = segue.destinationViewController as ArticleWebViewController
            articleWebViewController.url = articleURL
        }
    }
    

}
