//
//  CustomMenuWebView.swift
//  MenuItemKit-Swift
//
//  Created by Do Thang on 02/08/2022.
//  Copyright © 2022 lazyapps. All rights reserved.
//

import UIKit
import WebKit

class CustomMenuWebView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        customizeMenuInWebView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeMenuInWebView()
    }
}

// MARK: - Helper methods

extension CustomMenuWebView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(copy(_:)),
            #selector(pressMenu1(_:)),
            #selector(pressMenu2(_:)):
            
            return true
        default:
            break
        }
        
        return false
    }
    
    private func customizeMenuInWebView() {
        let menu1 = UIMenuItem(title: "Menu 1", image: UIImage(named: "ColorImage"), action: #selector(pressMenu1(_:)))
        let menu2 = UIMenuItem(title: "Menu 2", image: UIImage(named: "Image"), action: #selector(pressMenu2(_:)))
        
        let menuVC = UIMenuController.shared
        menuVC.menuItems = [menu1, menu2]
    }
    
    @objc private func pressMenu1(_ sender: UIMenuController?) {
        print("press menu 1")
    }
    
    @objc private func pressMenu2(_ sender: UIMenuController?) {
        print("press menu 2")
    }
}
