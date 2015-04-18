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
    
    let wiredXML = "http://wired.jp/rssfeeder/"
    let shikiXML =  "http://www.100shiki.com/feed"
    let cinraXML =   "http://www.cinra.net/rss-all.xml"
    
    var siteAicons:Array<UIButton>! = []
    
//    let blue = UIColor(red: 10/255, green: 81/255, blue: 166/255, alpha: 1)
//    let yellow = UIColor(red: 255/255, green: 213/255, blue: 90/255, alpha: 1)
//    let red = UIColor(red: 244/255, green: 104/255, blue: 96/255, alpha: 1)
    
    let blue = UIColor(red: 92/255, green: 192/255, blue: 210/255, alpha: 1)
    let yellow = UIColor(red: 105/255, green: 207/255, blue: 153/255, alpha: 1)
    let red = UIColor(red: 195/255, green: 123/255, blue: 175/255, alpha: 1)
    let black = UIColor(red: 50/255, green: 56/255, blue: 60/255, alpha: 1.0)
    let bb = UIColor(red: 0, green: 118, blue: 255, alpha: 1.0)
    
    var articles:Array<Article>! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ヘッダー
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //scrollView
        self.articleScrollView.delegate = self
        self.articleScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: articleScrollView.frame.height)
        self.articleScrollView.pagingEnabled = true
        
        //site top image
        setSiteTopImage(0, imageName: "wired_top_image", color: blue, text: "WIRED")
        setSiteTopImage(self.view.frame.width, imageName: "wsj_top_image", color: red, text: "100SHIKI")
        setSiteTopImage(self.view.frame.width*2, imageName: "100shiki_top_image", color: yellow, text: "CINRA.NET")
        
        //table view
        setArticleTableView(0, siteXML: wiredXML, tag: 1)
        setArticleTableView(self.view.frame.width, siteXML: shikiXML, tag: 2)
        setArticleTableView(self.view.frame.width*2, siteXML: cinraXML, tag: 3)
        
        //tabLable
//        setTabLabel(75/4 + 10, text: "WIRED", color: blue)
//        setTabLabel(75/4 + 100 + 75/4, text: "100SHIKI", color: red)
//        setTabLabel(75/4 + 200 + 75/2 - 10, text: "CINRA.NET", color: yellow)
        setTabLabel(self.view.center.x/2, text: "W", color: blue, tag: 1)
        setTabLabel(self.view.center.x, text: "100", color: red, tag: 2)
        setTabLabel(self.view.center.x*3/2, text: "C", color: yellow, tag: 3)
        
        siteAicons[0].setTitleColor(bb, forState: UIControlState.Normal)
        siteAicons[0].layer.borderColor = bb.CGColor
        
        
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func setArticleTableView(x: CGFloat, siteXML: String, tag: Int){
        var frame = CGRectMake(x, 200, self.view.frame.width, articleScrollView.frame.height - 200)
        var articleTableView = ArticleTableView(frame: frame)
        articleTableView.cutomDelegate = self
        articleScrollView.tag = tag
        articleTableView.loadRSS(siteXML, articleArray: articles)
        articleScrollView.addSubview(articleTableView)
    }
    
    func setTabLabel(x: CGFloat, text: String, color: UIColor, tag: Int){
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
        siteAicons!.append(tabButton)
        
//        var tabLabel = UILabel()
//        tabLabel.frame.size = CGSizeMake(36, 36)
//        tabLabel.center = CGPointMake(x, 44)
//        tabLabel.text = text
//        tabLabel.textColor = UIColor.whiteColor()
//        tabLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
//        tabLabel.backgroundColor = black
//        tabLabel.textAlignment = NSTextAlignment.Center
//        tabLabel.layer.cornerRadius = 18
//        tabLabel.layer.borderColor = UIColor.whiteColor().CGColor
//        tabLabel.layer.borderWidth = 1
//        tabLabel.layer.masksToBounds = true
//        self.headerView.addSubview(tabLabel)
//        siteAicons!.append(tabLabel)
    }
    
    func tapSiteIcon(sender: UIButton){
        if sender.tag == 1 {
            articleScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        } else if sender.tag == 2 {
            articleScrollView.setContentOffset(CGPointMake(self.view.frame.width, 0), animated: true)
        } else if sender.tag == 3 {
            articleScrollView.setContentOffset(CGPointMake(self.view.frame.width*2, 0), animated: true)
        }
    }
    
    func setSiteTopImage(x: CGFloat, imageName: String, color: UIColor, text: String){
        var siteTopImageView = UIImageView()
        siteTopImageView.frame = CGRectMake(x, 0, self.view.frame.width, 200)
        siteTopImageView.image = UIImage(named: imageName)
        siteTopImageView.contentMode = UIViewContentMode.ScaleAspectFill
        siteTopImageView.layer.masksToBounds = true
        articleScrollView.addSubview(siteTopImageView)
        
        setHeaderView(siteTopImageView, color: color, text: text)
    }
    
    func setHeaderView(imageView: UIImageView, color: UIColor, text: String){
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        headerView.backgroundColor = color
        headerView.alpha = 0.6
        imageView.addSubview(headerView)
        
        let siteNmae = UILabel()
        siteNmae.frame = headerView.frame
        siteNmae.text = text
        siteNmae.textAlignment = NSTextAlignment.Center
        siteNmae.textColor = UIColor.whiteColor()
        siteNmae.alpha = 1
        siteNmae.font = UIFont(name: "Helvetica-Light", size: 40)
        imageView.addSubview(siteNmae)
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollPoint = scrollView.contentOffset.x
        if scrollPoint == 0 {
            siteAicons[0].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[0].layer.borderColor = blue.CGColor
            siteAicons[1].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[1].layer.borderColor = UIColor.whiteColor().CGColor
            siteAicons[2].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[2].layer.borderColor = UIColor.whiteColor().CGColor
        } else if scrollPoint == 375 {
            siteAicons[0].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[0].layer.borderColor = UIColor.whiteColor().CGColor
            siteAicons[1].setTitleColor(red, forState: .Normal)
            siteAicons[1].layer.borderColor = red.CGColor
            siteAicons[2].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[2].layer.borderColor = UIColor.whiteColor().CGColor
        } else if scrollPoint == 750 {
            siteAicons[0].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[0].layer.borderColor = UIColor.whiteColor().CGColor
            siteAicons[1].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            siteAicons[1].layer.borderColor = UIColor.whiteColor().CGColor
            siteAicons[2].setTitleColor(yellow, forState: .Normal)
            siteAicons[2].layer.borderColor = yellow.CGColor
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegeu" {
            var article = sender as Article
            var articleWebViewController: ArticleWebViewController = segue.destinationViewController as ArticleWebViewController
            articleWebViewController.article = article
        }
    }
    
    
    func didSelectTableViewCell(article: Article) {
         self.performSegueWithIdentifier("articleSegeu", sender: article)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

}
