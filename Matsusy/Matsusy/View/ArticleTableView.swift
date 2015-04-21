//
//  ArticleTableView.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

//セルがタップされたことをArticleViewControllerに知らせてあげる
@objc protocol ArticleTableViewDelegate{
    func didSelectTableViewCell(article: Article)
}

class ArticleTableView: UITableView, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {

    var cutomDelegate: ArticleTableViewDelegate?
    var articles:Array<Article> = []
    var elementName = ""
    var siteImageName:String!
    var siteName:String!
    var siteColor:UIColor!
    
    let siteColors:Array<UIColor> = []
    
    
    //siwftのバグ
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        
        //セルの登録
        self.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        self.registerNib(UINib(nibName: "SiteTopTableViewCell", bundle: nil), forCellReuseIdentifier: "SiteTopTableViewCell")
    
    }
    
    //必ず必要(Interface Builderで生成した場合)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //RSS読み込み
    func loadRSS(siteXML: String, articleArray: Array<Article>) {
        articles = articleArray
        articles.removeAll(keepCapacity: false)
        if let url = NSURL(string: siteXML) {
            let request = NSURLRequest(URL: url)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let parser = NSXMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }).resume()
        }
    }
    
    //要素の読み込み開始が始まったタイミングで呼ばれる
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        self.elementName = elementName
        //記事の分だけArticleクラスのオブジェクトを生成し配列に入れる。
        if self.elementName == "item" {
            let article = Article()
            self.articles.append(article)
        }
    }
    
    //指定したタグの中身を取得
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if articles.count > 0 {
            var lastArticle = self.articles.last
            if self.elementName == "title" {
                lastArticle?.title += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if self.elementName == "description" {
                lastArticle?.descript += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if self.elementName == "pubDate" {
                lastArticle?.date += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if self.elementName == "link" {
                lastArticle?.link += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            }
        }
    }
    
    //XMLパース終了
    func parserDidEndDocument(parser: NSXMLParser!) {
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadData()
        })
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return articles.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        else {
            return 85
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SiteTopTableViewCell", forIndexPath: indexPath) as SiteTopTableViewCell
            cell.siteNameLabel.text = siteName
            cell.siteTopImageView.image = UIImage(named: siteImageName)
            cell.imageMaskView.backgroundColor = siteColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as ArticleTableViewCell
            var article = self.articles[indexPath.row] as Article

            cell.title.text = article.title
            cell.descript.text = article.descript
            cell.date.text = conversionDateFormt(article.date)
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var article = articles[indexPath.row]
        
        //ArticleViewControllerにセルがタップされたことを通知
        self.cutomDelegate?.didSelectTableViewCell(article)
    }

    
    //取得した日付のフォーマットを変
    func conversionDateFormt(dateString:String) -> String {
        println("ぷり")
        println(dateString)
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date: NSDate? = formatter.dateFromString(dateString)
        
        let newFormatter = NSDateFormatter()
        newFormatter.dateFormat = "yyy/MM/dd HH:mm"
        println(date)
        var newDateString = newFormatter.stringFromDate(date!)
        return newDateString
    }

}
