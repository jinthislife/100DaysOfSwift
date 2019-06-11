//
//  DetailViewController.swift
//  Project7
//
//  Created by LeeKyungjin on 02/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width", initial-scale=1">
        <style></style>
        </head>
        <body>
        <h1 style="font-family:helvetica;">\(detailItem.title)</h1>
        <p style="font-family:helvetica; font-size:120%; font-color:dimgray;">\(detailItem.body)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
