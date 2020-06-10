//
//  WebController.swift
//  Cornelis Assesment
//
//  Created by Cornelis Kuijpers on 2020/06/10.
//  Copyright © 2020 Cor Kuijpers. All rights reserved.
//

import UIKit
import WebKit

class WebController : UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var question_id: Int?
    var webView: WKWebView!
    
    func webView(_ webView: WKWebView,
      didFinish navigation: WKNavigation!) {
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let Safequestion_id = question_id {
            let myURL = URL(string:"https://stackoverflow.com/questions/\(Safequestion_id)")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }else{
            print("Invalid Question ID")
        }
    }
    
    
    
}
