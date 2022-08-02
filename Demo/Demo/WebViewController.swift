//
//  WebViewController.swift
//  MenuItemKit-Swift
//
//  Created by Do Thang on 02/08/2022.
//  Copyright © 2022 lazyapps. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configWebView()
    }
    
    private func configWebView() {
        // https://www.apple.com
        let url = URL(string: "https://webflow.com/blog/business-website-examples")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
