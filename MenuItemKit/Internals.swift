//
//  Internals.swift
//  MenuItemKit
//
//  Created by CHEN Xian’an on 1/17/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import ObjectiveC.runtime

let imageItemIdetifier = "\u{FEFF}\u{200B}"

let blockIdentifierPrefix = "_menuitemkit_block_"

func setNewIMPWithBlock<T>(block: T, forSelector selector: Selector, toClass klass: AnyClass) {
  let method = class_getInstanceMethod(klass, selector)
  let imp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
  if !class_addMethod(klass, selector, imp, method_getTypeEncoding(method)) {
    method_setImplementation(method, imp)
  }
}

func isMenuItemKitSelector(str: String) -> Bool {
  return str.hasPrefix(blockIdentifierPrefix)
}

func isMenuItemKitSelector(sel: Selector) -> Bool {
  return isMenuItemKitSelector(NSStringFromSelector(sel))
}

extension NSObject {

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

  @nonobjc
  func associatedBoxForKey<T>(key: StaticString, initialValue: () -> T) -> Box<T> {
    return associatedBoxForKey(key, initialValue: initialValue())
  }

}

// MARK: Box wrapper
final class Box<T> {

  var value: T

  init(_ val: T) {
    value = val
  }
  
}
