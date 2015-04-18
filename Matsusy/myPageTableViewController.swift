//
//  myPageTableViewController.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/17.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class myPageTableViewController: UITableViewController {

    var myArticle = MyArticle.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //セルの登録
        self.tableView.registerNib(UINib(nibName: "myTopTableViewCell", bundle: nil), forCellReuseIdentifier: "myTopTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
        //編集ボタン追加
        self.navigationItem.leftBarButtonItem = editButtonItem()
        
        //NSUSerDefaultsから値を取り出す
        myArticle.getMyArticle()
        
//        tableView.contentInset.bottom = 49    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //最初のセルはアイコン用
        return myArticle.myArticles.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell: myTopTableViewCell = tableView.dequeueReusableCellWithIdentifier("myTopTableViewCell", forIndexPath: indexPath) as myTopTableViewCell
            return cell
        } else {
            var cell: ArticleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as ArticleTableViewCell
            var article = myArticle.myArticles[indexPath.row - 1]

            var titleLabel = cell.viewWithTag(1) as UILabel
            var descriptLabel = cell.viewWithTag(2) as UILabel
            var dateLabel = cell.viewWithTag(3) as UILabel
            
            titleLabel.text = article.title
            descriptLabel.text = article.descript
            dateLabel.text = conversionDateFormt(article.date)
            
            //セルの境界線を消す
            tableView.tableFooterView = UILabel()
            
            return cell
        }
    }
    
    
    //セルの高さ
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight:CGFloat
        if indexPath.row == 0 {
            cellHeight = 200
        } else {
            cellHeight = 85
        }
        return cellHeight
    }

    
    //セルが編集可能か設定
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    
    //セルを削除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            //myArticles配列の更新(削除した要素を除き、NSUserDefaltsで再保存)
            myArticle.updateMyArticle(indexPath.row-1)
            //実際にテーブルビューからセルを削除
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    

    //セルを選択した時
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            var article = myArticle.myArticles[indexPath.row - 1]
            myArticle.save()
            self.performSegueWithIdentifier("articleSegeu", sender: article)
        }
    }

    //画面遷移時に値を受け渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegeu" {
            var articleWebViewController = segue.destinationViewController as ArticleWebViewController
            var article = sender as Article!
            articleWebViewController.article = article
        }
    }
    
    
    //取得した日付のフォーマットを変換
    func conversionDateFormt(dateString:String) -> String {
        //取得したフォーマットでNSDateを取得
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date: NSDate? = formatter.dateFromString(dateString)
        //NSDateから取得したいフォーマットで文字列で出力
        let newFromatter = NSDateFormatter()
        formatter.dateFormat = "yyy/MM/dd HH:mm"
        var newDateString = formatter.stringFromDate(date!)
        return newDateString
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
