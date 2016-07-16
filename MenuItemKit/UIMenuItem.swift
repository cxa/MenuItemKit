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
  convenience init(title: String, image: UIImage?, action: MenuItemAction) {
    let title = image != nil ? title + imageItemIdetifier : title
    self.init(title: title, action: Selector(blockIdentifierPrefix + NSUUID.stripedString + ":"))
    imageBox.value = image
    actionBox.value = action
  }

  @objc(mik_initWithTitle:action:)
  convenience init(title: String, action: MenuItemAction) {
    self.init(title: title, image: nil, action: action)
  }

//  convenience init(image: UIImage, handler: MenuItemHandler) {
//    let selector = image_identifier_prefix + NSUUID.stripedString + ":"
//    self.init(title: selector, action: Selector(selector))
//    imageBox.value = image
//    handlerBox.value = handler
//  }

}

extension UIMenuItem {

  @nonobjc
  var imageBox: Box<UIImage?> {
    let key: StaticString = #function
    return associatedBoxForKey(key, initialValue: nil)
  }

  @nonobjc
  var actionBox: Box<MenuItemAction?> {
    let key: StaticString = #function
    return associatedBoxForKey(key, initialValue: nil)
  }

  @nonobjc
  func associatedBoxForKey<T>(key: StaticString, @autoclosure initialValue: () -> T) -> Box<T> {
    guard let box = objc_getAssociatedObject(self, key.utf8Start) as? Box<T> else {
      let box = Box(initialValue())
      objc_setAssociatedObject(self, key.utf8Start, box as AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return box
    }
    
    return box
  }
  
}

// MARK: Box wrapper
final class Box<T> {
  
  var value: T
  
  init(_ val: T) {
    value = val
  }
  
}

// MARK: NSUUID
private extension NSUUID {
  
  static var stripedString: String {
    return NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "_")
  }
  
}
