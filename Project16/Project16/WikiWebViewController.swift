//
//  WikiWebViewController.swift
//  Project16
//
//  Created by LeeKyungjin on 07/05/2019.
//  Copyright © 2019 daisy. All rights reserved.
//

import UIKit
import WebKit

class WikiWebViewController: UIViewController {

    var entry: String = ""

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = entry.capitalized
        
        let urlString = "https://en.wikipedia.org/wiki/\(entry.capitalized)"
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        webView.load(urlRequest)
    }

}
