//
//  ViewController.swift
//  Swift News
//
//  Created by Takayama on 2015/01/26.
//  Copyright (c) 2015年 Hiroshi Takayama. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var entries = NSMutableArray()
    
    let newsUrlStrings = [
        
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.rssad.jp/rss/impresswatch/pcwatch.rdf&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.itmedia.co.jp/rss/2.0/news_bursts.xml&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://jp.techcrunch.com/feed/&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.gizmodo.jp/rss/gizmodo/index.xml&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://gigazine.net/index.php?/news/rss_2.0/&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.feedburner.com/gorime?format=xml&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.japan.cnet.com/rss/cnet/all.rdf&num=8"
        
    ]
    
    let imageNames = [
    "pcw", "itmedia" , "tech","gizmodo","gigazine","gorime","cnet"
    
    ]

    @IBAction func refresh(sender: AnyObject) {
        entries.removeAllObjects()  //removeAllObjectsはNSMutableArrayクラスで利用可能なメソッド
        
        for newsUrlString in newsUrlStrings {
        var url = NSURL(string: newsUrlString)!
            // newsUrlStringsに格納されている配列のループを回し、1つずつ取り出して、それを変数urlへ格納する
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            // NSURLSession.sharedSession()でセッションを作成（バックグラウンドで接続）し、
            // データ取得元のURL、完了後のハンドラを元にdataTaskWithURL:completionHandler:で通信タスクを生成
            

            /* 通信完了後の処理を下記へ記述 */
            
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            // NSJSONSerializationクラスの JSONObjectWithData:options:error: は JSON から NSArray or NSDictionary への変換 をするメソッド
            // optionsで NSJSONReadingOptionsを指定すると、NSArrayやNSDictionaryの代わりに、可変オブジェクトNSMutableArrayやNSMutableDictionaryを返す
            
            if var responseData = dict["responseData"] as? NSDictionary {
                // 変数[] という形はsubscriptで、自分で指定したkeyを与える
                if var feed = responseData["feed"] as? NSDictionary {
                    if var entries = feed["entries"] as? NSArray {
                        var formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en-US")
                        // formatterの言語を設定する(localeにて) localeIdentifierで各国の表示に合わせた設定をしてくれる
                        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzzz"
                        
                        for var i = 0; i < entries.count; i++ {
                            var entry = entries[i] as! NSMutableDictionary
                            
                            entry["url"] = newsUrlString
                            
                            var dateStr = entry["publishedDate"] as! String
                            // String型としてentryのpublishedDateをdateStrに格納
                            var date = formatter.dateFromString(dateStr)
                            // 文字列をNSDate型に変換
                            entry["date"] = date
                            // entryの構造体へ格納
                        }
                        
                        self.entries.addObjectsFromArray(entries as [AnyObject])
                        self.entries.sortUsingComparator({ object1, object2 in
                            // 配列を取り出して最新順にソート
                        
                            var date1 = object1["date"] as! NSDate
                            var date2 = object2["date"] as! NSDate
                            
                            var order = date1.compare(date2)
                            
                            if order == NSComparisonResult.OrderedAscending {
                                // ascendingは昇っていく
                                return NSComparisonResult.OrderedDescending
                                // Descendingは下っていく
                                // 上記は比較演算子。これはセットで覚える
                            }
                            else if order == NSComparisonResult.OrderedDescending{
                                return NSComparisonResult.OrderedAscending
                            }
                            return order
                        })
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                // 非同期処理の中で、dispatch_sync()とdispatch_get_main_queue()によって処理をメインスレッドに投げ込む
                
                self.tableView.reloadData()
            })
        })
        task.resume()
            // taskをresumeして、実行を再び始める
            
        } //for文はここで終了
    } // refreshアクションはここで終了
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        entries.removeAllObjects()  //removeAllObjectsはNSMutableArrayクラスで利用可能なメソッド
        
        for newsUrlString in newsUrlStrings {
            var url = NSURL(string: newsUrlString)!
            // newsUrlStringsに格納されている配列のループを回し、1つずつ取り出して、それを変数urlへ格納する
            
            var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
                // NSURLSession.sharedSession()でセッションを作成（バックグラウンドで接続）し、
                // データ取得元のURL、完了後のハンドラを元にdataTaskWithURL:completionHandler:で通信タスクを生成
                
                
                /* 通信完了後の処理を下記へ記述 */
                
                var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                // NSJSONSerializationクラスの JSONObjectWithData:options:error: は JSON から NSArray or NSDictionary への変換 をするメソッド
                // optionsで NSJSONReadingOptionsを指定すると、NSArrayやNSDictionaryの代わりに、可変オブジェクトNSMutableArrayやNSMutableDictionaryを返す
                
                if var responseData = dict["responseData"] as? NSDictionary {
                    // 変数[] という形はsubscriptで、自分で指定したkeyを与える
                    if var feed = responseData["feed"] as? NSDictionary {
                        if var entries = feed["entries"] as? NSArray {
                            var formatter = NSDateFormatter()
                            formatter.locale = NSLocale(localeIdentifier: "en-US")
                            // formatterの言語を設定する(localeにて) localeIdentifierで各国の表示に合わせた設定をしてくれる
                            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzzz"
                            
                            for var i = 0; i < entries.count; i++ {
                                var entry = entries[i] as! NSMutableDictionary
                                
                                entry["url"] = newsUrlString
                                
                                var dateStr = entry["publishedDate"] as! String
                                // String型としてentryのpublishedDateをdateStrに格納
                                var date = formatter.dateFromString(dateStr)
                                // 文字列をNSDate型に変換
                                entry["date"] = date
                                // entryの構造体へ格納
                            }
                            
                            self.entries.addObjectsFromArray(entries as [AnyObject])
                            self.entries.sortUsingComparator({ object1, object2 in
                                // 配列を取り出して最新順にソート
                                
                                var date1 = object1["date"] as! NSDate
                                var date2 = object2["date"] as! NSDate
                                
                                var order = date1.compare(date2)
                                
                                if order == NSComparisonResult.OrderedAscending {
                                    // ascendingは昇っていく
                                    return NSComparisonResult.OrderedDescending
                                    // Descendingは下っていく
                                    // 上記は比較演算子。これはセットで覚える
                                }
                                else if order == NSComparisonResult.OrderedDescending{
                                    return NSComparisonResult.OrderedAscending
                                }
                                return order
                            })
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    // 非同期処理の中で、dispatch_sync()とdispatch_get_main_queue()によって処理をメインスレッドに投げ込む
                    
                    self.tableView.reloadData()
                })
            })
            task.resume()
            // taskをresumeして、実行を再び始める
            
        } //for文はここで終了
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("news") as! UITableViewCell
        // 指定された箇所のセルを作成する。ここでは"news"というセル
        
        var entry = entries[indexPath.row] as! NSDictionary
        
        // titleLabelの設定
        var titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = entry["title"] as? String
        
        // descriptionLabelの設定
        var descriptionLabel = cell.viewWithTag(2) as! UILabel
        descriptionLabel.text = entry["contentSnippet"] as? String
        
        // dateの設定
        var date = entry["date"] as! NSDate
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        var dateLabel = cell.viewWithTag(3) as! UILabel
        dateLabel.text = formatter.stringFromDate(date)
        
        //　接続するURLの設定
        var urlString = entry["url"] as! String
        var index = find(newsUrlStrings, urlString)
        var imageName = imageNames[index!]
        var image = UIImage(named: imageName)
        var imageView = cell.viewWithTag(4) as! UIImageView
        imageView.image = image

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender: entries[indexPath.row])
        // performSegueWithIdentifierはIDを設定した上で画面遷都するメソッド
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue を使って画面遷移する際に情報を渡すには、prepareForSegue:sender: メソッドを実装
        if segue.identifier == "detail" {
            var detailController = segue.destinationViewController as! DetailController
            // segue.destinationViewController で ViewControllerとしてプロパティを渡す
            
            detailController.entry = sender as! NSDictionary
        }
    }
}

