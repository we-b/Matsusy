//
//  myArticle.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/17.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class ArticleStocks: NSObject {

    var myArticles: Array<Article> = []
    
    //bookmarkに追加
    func addArticleStocks(articleModel: Article) {
        self.myArticles.insert(articleModel, atIndex: 0)
        save()
    }
    
    
    //編集
    func removeMyArticle(index: Int){
        self.myArticles.removeAtIndex(index)
        save()
    }
    
    
    func save(){
        var tmpArticles: Array<Dictionary<String, AnyObject>> = []
        for article in self.myArticles {
            var articleDic = convertDictionary(article)
            tmpArticles.append(articleDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tmpArticles, forKey: "myArticles")
        defaults.synchronize()
    }
    
    
    //NSUserDefaultsから取り出す
    func getMyArticle() -> Array<Article> {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let articles = defaults.objectForKey("myArticles") as? Array<Dictionary<String, String>> {
            for dic in articles {
                var article = convertArticleModel(dic)
                self.myArticles.append(article)
            }
        }
        return self.myArticles
    }
    
    
    //dictionary => Article Model
    func convertArticleModel(dic: Dictionary<String, String>) -> Article {
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
    class var sharedInstance: ArticleStocks {
        struct Static {
            static let instance: ArticleStocks = ArticleStocks()
        }
        return Static.instance
    }
    
}
