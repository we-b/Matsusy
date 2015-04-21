//
//  ArticleViewController.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate, ArticleTableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var articleScrollView: UIScrollView!
    
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    var siteButtons:Array<UIButton>! = []
    var articles:Array<Article>! = []
    
    let wiredURL = "http://wired.jp/rssfeeder/"
    let shikiURL =  "http://www.100shiki.com/feed"
    let cinraURL =   "http://www.cinra.net/rss-all.xml"
    
    let blue = UIColor(red: 92/255, green: 192/255, blue: 210/255, alpha: 1)
    let yellow = UIColor(red: 105/255, green: 207/255, blue: 153/255, alpha: 1)
    let red = UIColor(red: 195/255, green: 123/255, blue: 175/255, alpha: 1)
    let black = UIColor(red: 50/255, green: 56/255, blue: 60/255, alpha: 1.0)
    let bb = UIColor(red: 0, green: 118, blue: 255, alpha: 1.0)
    
    let wired = "WIRED"
    let shiki = "100SHIKI"
    let shikishiki = "CINRA.NET"
    
    let wiredImageName = "wired_top_image"
    let shikiImageName = "wsj_top_image"
    let cinraImageName = "100shiki_top_image"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        //scrollView
        self.articleScrollView.delegate = self
        self.articleScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: articleScrollView.frame.height)
        self.articleScrollView.pagingEnabled = true
        
        
        //table view
        setArticleTableView(0, siteURL: wiredURL, siteName: wired, siteImageName: wiredImageName, color: blue)
        setArticleTableView(screenWidth, siteURL: shikiURL, siteName: shiki, siteImageName: shikiImageName, color: red)
        setArticleTableView(screenWidth*2, siteURL: cinraURL, siteName: shikishiki, siteImageName: cinraImageName, color: yellow)
        
        //tabButton
        setTabButton(self.view.center.x/2, text: "W", color: blue, tag: 1)
        setTabButton(self.view.center.x, text: "100", color: red, tag: 2)
        setTabButton(self.view.center.x*3/2, text: "C", color: yellow, tag: 3)
        
        //tabButtonの初めの状態
        setInitalStateTabButton()
    
    }

    override func viewWillAppear(animated: Bool) {
        //ナビゲーションバー非表示
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setInitalStateTabButton(){
        let initalSiteButton = siteButtons[0]
        initalSiteButton.setTitleColor(bb, forState: UIControlState.Normal)
        initalSiteButton.layer.borderColor = bb.CGColor
    }

    
    func setArticleTableView(x: CGFloat, siteURL: String, siteName: String, siteImageName: String, color: UIColor) {
        //フッターの分の49pxも引く
        let frame = CGRectMake(x, 0, self.view.frame.width, articleScrollView.frame.height-49)
        let articleTableView = ArticleTableView(frame: frame)
        articleTableView.cutomDelegate = self
        articleTableView.siteImageName = siteImageName
        articleTableView.siteName = siteName
        articleTableView.siteColor = color
        articleTableView.loadRSS(siteURL, articleArray: articles)
        articleScrollView.addSubview(articleTableView)
    }
    
    func setTabButton(x: CGFloat, text: String, color: UIColor, tag: Int){
        var tabButton = UIButton()
        tabButton.frame.size = CGSizeMake(36, 36)
        tabButton.center = CGPointMake(x, 44)
        tabButton.setTitle(text, forState: UIControlState.Normal)
        tabButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabButton.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 13)
        tabButton.backgroundColor = black
        tabButton.tag = tag
        tabButton.addTarget(self, action: "tapSiteIcon:", forControlEvents: UIControlEvents.TouchUpInside)
        tabButton.layer.cornerRadius = 18
        tabButton.layer.borderColor = UIColor.whiteColor().CGColor
        tabButton.layer.borderWidth = 1
        tabButton.layer.masksToBounds = true
        self.headerView.addSubview(tabButton)
        siteButtons!.append(tabButton)
    }
    
    func tapSiteIcon(sender: UIButton){
        var pointX = screenWidth * CGFloat(sender.tag - 1)
        articleScrollView.setContentOffset(CGPointMake(pointX, 0), animated: true)
    }
    
    //スクロールが終了時に呼ばれる
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollPointX = scrollView.contentOffset.x
        if scrollPointX == 0 {
            siteButton(0, color: blue)
            siteButton(1, color: UIColor.whiteColor())
            siteButton(2, color: UIColor.whiteColor())
        } else if scrollPointX == screenWidth {
            siteButton(0, color: UIColor.whiteColor())
            siteButton(1, color: red)
            siteButton(2, color: UIColor.whiteColor())
        } else if scrollPointX == screenWidth*2 {
            siteButton(0, color: UIColor.whiteColor())
            siteButton(1, color: UIColor.whiteColor())
            siteButton(2, color: yellow)
        }
    }
    
    func siteButton(index: Int, color: UIColor) {
        siteButtons[index].setTitleColor(color, forState: .Normal)
        siteButtons[index].layer.borderColor = color.CGColor
    }

    //画面遷移時に値を受け渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegue" {
            var article = sender as Article
            var articleWebViewController: ArticleWebViewController = segue.destinationViewController as ArticleWebViewController
            articleWebViewController.article = article
        }
    }
    
    //自作デリゲートメソッド
    func didSelectTableViewCell(article: Article) {
         self.performSegueWithIdentifier("articleSegue", sender: article)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

}
