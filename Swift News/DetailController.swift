//
//  DetailController.swift
//  Swift News
//
//  Created by Takayama on 2015/01/26.
//  Copyright (c) 2015年 Hiroshi Takayama. All rights reserved.
//

import UIKit
import Social

class DetailController: UIViewController {
    
    var entry = NSDictionary()
    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        var url = NSURL(string: self.entry["link"] as! String)!
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    @IBAction func twitter(sender: AnyObject) {
        // twitterへ投稿が使えるか確認
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            
            // コントローラーを作る
            var controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            // リンクを追加する
            let link = entry["link"] as! String
            let url = NSURL(string: link)
            controller.addURL(url)
            
            // テキストを追加する
            let title = entry["title"] as! String
            controller.setInitialText(title)
            
            // 投稿画像を表示する
            presentViewController(controller, animated: true, completion: {})
        }

    }
    
    @IBAction func facebook(sender: AnyObject) {
        
        // Facebookへ投稿が使えるか確認
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            
            // コントローラーを作る
            var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            // リンクを追加する
            let link = entry["link"] as! String
            let url = NSURL(string: link)
            controller.addURL(url)
            
            // テキストを追加する
            let title = entry["title"] as! String
            controller.setInitialText(title)
            
            // 投稿画像を表示する
            presentViewController(controller, animated: true, completion: {})
        }
    }
}

