//
//  myArticle.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/17.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class MyArticle: NSObject {

    var myArticles: Array<Article> = []
    
    
    //保存
    func save(articleModel: Article) {
        self.myArticles.append(articleModel)
        save()
    }
    
    func updateMyArticle(index: Int){
        self.myArticles.removeAtIndex(index)
        save()
    }
    
    func save(){
        var articles: Array<Dictionary<String, AnyObject>> = []
        for article in self.myArticles {
            var articleDic = convertDictionary(article)
            articles.append(articleDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(articles, forKey: "myArticles")
        defaults.synchronize()
    }
    
    
    //取り出す
    func getMyArticle() -> Array<Article> {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let articles = defaults.objectForKey("myArticles") as? Array<Dictionary<String, String>> {
            for dic in articles {
                var article = convertArticleMolel(dic)
                self.myArticles.append(article)
            }
        }
        return self.myArticles
    }
    
    //dictionary => Article Model
    func convertArticleMolel(dic: Dictionary<String, String>) -> Article {
        var article = Article()
        article.title = dic["title"]!
        article.descript = dic["descript"]!
        article.date = dic["date"]!
        article.link = dic["link"]!
        return article
    }
    
    //Article Model => dictionary
    func convertDictionary(article : Article) -> Dictionary<String, AnyObject>{
        var dic = Dictionary<String, AnyObject>()
        dic["title"] = article.title
        dic["descript"] = article.descript
        dic["date"] = article.date
        dic["link"] = article.link
        return dic
    }

    
    //シングルトン
    class var sharedInstance: MyArticle {
        struct Static {
            static let instance: MyArticle = MyArticle()
        }
        return Static.instance
    }
    
}
