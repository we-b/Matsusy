//
//  ArticleTableView.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/16.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class ArticleTableView: UITableView, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate{

    var articles:Array<Article> = []
    var elementName = ""
    

    //siwftのバグ
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        self.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
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
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if articles.count > 0 {
            var lastArticle = self.articles.last
            if self.elementName == "title" {
                lastArticle?.title += string
            } else if self.elementName == "description" {
                lastArticle?.descript += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if self.elementName == "pubDate" {
                lastArticle?.date += string
            } else if self.elementName == "link" {
                lastArticle?.link += string
            }
        }
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadData()
        })
    }
    
//     tabel view data sourse
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as UITableViewCell
        var article = self.articles[indexPath.row] as Article
        var titleLabel = cell.viewWithTag(1) as UILabel
        titleLabel.text = article.title
        var descriptLable = cell.viewWithTag(2) as UILabel
        descriptLable.text = article.descript
        var dateLabel = cell.viewWithTag(3) as UILabel
        dateLabel.text = article.date
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var articleURL = articles[indexPath.row].link
        ArticleViewController().segeToWeb(articleURL)
    }
    

}
