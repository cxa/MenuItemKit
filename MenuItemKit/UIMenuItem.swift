//
//  UIMenuItem.swift
//  MenuItemKit
//
//  Created by CHEN Xian’an on 1/16/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

public extension UIMenuItem {

  @objc(mik_initWithTitle:image:action:)
  convenience init(title: String, image: UIImage?, action: @escaping MenuItemAction) {
    let title = image != nil ? title + imageItemIdetifier : title
    self.init(title: title, action: Selector(blockIdentifierPrefix + UUID.stripedString + ":"))
    imageBox.value = image
    actionBox.value = action
  }

  @objc(mik_initWithTitle:action:)
  convenience init(title: String, action: @escaping MenuItemAction) {
    self.init(title: title, image: nil, action: action)
  }
  
}

// MARK: NSUUID
private extension UUID {
  
  static var stripedString: String {
    return UUID().uuidString.replacingOccurrences(of: "-", with: "_")
  }
  
}
