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
        
        self.tableView.registerNib(UINib(nibName: "myTopTableViewCell", bundle: nil), forCellReuseIdentifier: "myTopTableViewCell")
        
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        self.navigationItem.leftBarButtonItem = editButtonItem()
        
        myArticle.getMyArticle()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
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
            titleLabel.text = article.title
            
            var descriptLabel = cell.viewWithTag(2) as UILabel
            descriptLabel.text = article.descript
            
            var dateLabel = cell.viewWithTag(3) as UILabel
            println(article.date)
            dateLabel.text = conversionDateFormt(article.date)
            
            var separator:UIView = UILabel()
            tableView.tableFooterView = separator
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight:CGFloat
        if indexPath.row == 0 {
            cellHeight = 200
        } else {
            cellHeight = 85
        }
        return cellHeight
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            println("-------------------------------------")
            println(self.myArticle.myArticles)
            println(indexPath.row-1)
            myArticle.updateMyArticle(indexPath.row-1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            var article = myArticle.myArticles[indexPath.row - 1]
            myArticle.save()
            self.performSegueWithIdentifier("articleSegeu", sender: article)
        }
    }
//

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegeu" {
            var articleWebViewController = segue.destinationViewController as ArticleWebViewController
            var article = sender as Article!
            articleWebViewController.article = article
        }
    }
    
    //取得した日付のフォーマットを変換
    func conversionDateFormt(dateString:String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date: NSDate? = formatter.dateFromString(dateString)
        
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
