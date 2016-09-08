//
//  UIMenuController.swift
//  MenuItemKit
//
//  Created by CHEN Xian’an on 1/17/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

// This is inspired by https://github.com/steipete/PSMenuItem
private func swizzle(class klass: AnyClass) {
  objc_sync_enter(klass)
  defer { objc_sync_exit(klass) }
  let key: StaticString = #function
  guard objc_getAssociatedObject(klass, key.utf8Start) == nil else { return }
  if true {
    // swizzle canBecomeFirstResponder
    let selector = #selector(getter: UIResponder.canBecomeFirstResponder)
    let block: @convention(block) (AnyObject) -> Bool = { _ in true }
    setNewIMPWithBlock(block, forSelector: selector, toClass: klass)
  }

  if true {
    // swizzle canPerformAction:withSender:
    let selector = #selector(UIResponder.canPerformAction(_:withSender:))
    let origIMP = class_getMethodImplementation(klass, selector)
    typealias IMPType = @convention(c) (AnyObject, Selector, Selector, AnyObject) -> Bool
    let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
    let block: @convention(block) (AnyObject, Selector, AnyObject) -> Bool = {
      return isMenuItemKitSelector($1) ? true : origIMPC($0, selector, $1, $2)
    }

    setNewIMPWithBlock(block, forSelector: selector, toClass: klass)
  }

  if true {
    // swizzle methodSignatureForSelector:
    let selector = NSSelectorFromString("methodSignatureForSelector:")
    let origIMP = class_getMethodImplementation(klass, selector)
    typealias IMPType = @convention(c) (AnyObject, Selector, Selector) -> AnyObject
    let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
    let block: @convention(block) (AnyObject, Selector) -> AnyObject = {
      if isMenuItemKitSelector($1) {
        // `NSMethodSignature` is not allowed in Swift, this is a workaround
        return NSObject.perform(NSSelectorFromString("_mik_fakeSignature")).takeUnretainedValue()
      }

      return origIMPC($0, selector, $1)
    }

    setNewIMPWithBlock(block, forSelector: selector, toClass: klass)
  }

  if true {
    // swizzle forwardInvocation:
    // `NSInvocation` is not allowed in Swift, so we just use AnyObject
    let selector = NSSelectorFromString("forwardInvocation:")
    let origIMP = class_getMethodImplementation(klass, selector)
    typealias IMPType = @convention(c) (AnyObject, Selector, AnyObject) -> ()
    let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
    let block: @convention(block) (AnyObject, AnyObject) -> () = {
      if isMenuItemKitSelector($1.selector) {
        guard let item = UIMenuController.shared.findMenuItemBySelector($1.selector) else { return }
        item.actionBox.value?(item)
      } else {
        origIMPC($0, selector, $1)
      }
    }

    setNewIMPWithBlock(block, forSelector: selector, toClass: klass)
  }

  objc_setAssociatedObject(klass, key.utf8Start, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

private extension UIMenuController {

  @objc class func _mik_load() {
    if true {
      let selector = #selector(setter: menuItems)
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, AnyObject) -> ()
      let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
      let block: @convention(block) (AnyObject, AnyObject) -> () = {
        if let firstResp = UIResponder.mik_firstResponder {
          swizzle(class: type(of: firstResp))
        }
        
        origIMPC($0, selector, makeUniqueImageTitles($1))
      }
      
      setNewIMPWithBlock(block, forSelector: selector, toClass: self)
    }
    
    if true {
      let selector = #selector(setTargetRect(_:in:))
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, CGRect, UIView) -> ()
      let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
      let block: @convention(block) (AnyObject, CGRect, UIView) -> () = {
        if let firstResp = UIResponder.mik_firstResponder {
          swizzle(class: type(of: firstResp))
        } else {
          swizzle(class: type(of: $2))
          // Must call `becomeFirstResponder` since there's no firstResponder yet
          $2.becomeFirstResponder()
        }
        
        origIMPC($0, selector, $1, $2)
      }
      
      setNewIMPWithBlock(block, forSelector: selector, toClass: self)
    }
  }

  static func makeUniqueImageTitles(_ itemsObj: AnyObject) -> AnyObject {
    guard let items = itemsObj as? [UIMenuItem] else { return itemsObj }
    var dic = [String: [UIMenuItem]]()
    items.filter { $0.title.hasSuffix(imageItemIdetifier) }.forEach { item in
      if dic[item.title] == nil { dic[item.title] = [] }
      dic[item.title]?.append(item)
    }

    dic.filter { $1.count > 1 }.flatMap { $1 }.enumerated().forEach { index, item in
      item.title = (0...index).map { _ in imageItemIdetifier }.joined(separator: "")
    }

    return items as AnyObject
  }

  func findImageItemByTitle(_ title: String?) -> UIMenuItem? {
    guard title?.hasSuffix(imageItemIdetifier) == true else { return nil }
    return menuItems?.lazy.filter { $0.title == title }.first
  }

  func findMenuItemBySelector(_ selector: Selector?) -> UIMenuItem? {
    guard let selector = selector else { return nil }
    return menuItems?.lazy.filter { sel_isEqual($0.action, selector) }.first
  }

  func findMenuItemBySelector(_ selector: String?) -> UIMenuItem? {
    guard let selStr = selector else { return nil }
    return findMenuItemBySelector(NSSelectorFromString(selStr))
  }

}

private extension UILabel {

  @objc class func _mik_load() {
    if true {
      let selector = #selector(drawText(in:))
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (UILabel, Selector, CGRect) -> ()
      let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
      let block: @convention(block) (UILabel, CGRect) -> () = { label, rect in
        guard
          let item = UIMenuController.shared.findImageItemByTitle(label.text),
          let _ = item.imageBox.value
        else { return origIMPC(label, selector, rect) }
      }

      setNewIMPWithBlock(block, forSelector: selector, toClass: self)
    }

    if true {
      let selector = #selector(layoutSubviews)
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (UILabel, Selector) -> ()
      let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
      let block: @convention(block) (UILabel) -> () = { label in
        guard
          let item = UIMenuController.shared.findImageItemByTitle(label.text),
          let image = item.imageBox.value
        else { return origIMPC(label, selector) }

        // Workaround for #9: https://github.com/cxa/MenuItemKit/issues/9
        let point = CGPoint(
          x: (label.bounds.width  - image.size.width)  / 2,
          y: (label.bounds.height - image.size.height) / 2)
        let imageView: Box<UIImageView> = label.associatedBoxForKey(#function, initialValue: { [weak label] in
          let imgView = UIImageView(frame: .zero)
          label?.addSubview(imgView)
          return imgView
        }())

        imageView.value.image = image
        imageView.value.frame = CGRect(origin: point, size: image.size)
      }

      setNewIMPWithBlock(block, forSelector: selector, toClass: self)
    }

    if true {
      let selector = #selector(setter: frame)
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (UILabel, Selector, CGRect) -> ()
      let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
      let block: @convention(block) (UILabel, CGRect) -> () = { label, rect in
        let isImageItem = UIMenuController.shared.findImageItemByTitle(label.text)?.imageBox.value != nil
        let rect = isImageItem ? label.superview?.bounds ?? rect : rect
        origIMPC(label, selector, rect)
      }

      setNewIMPWithBlock(block, forSelector: selector, toClass: self)
    }
  }
  
}

private extension NSString {
  
  @objc class func _mik_load() {
    let selector = #selector(size(attributes:))
    let origIMP = class_getMethodImplementation(self, selector)
    typealias IMPType = @convention(c) (NSString, Selector, AnyObject) -> CGSize
    let origIMPC = unsafeBitCast(origIMP, to: IMPType.self)
    let block: @convention(block) (NSString, AnyObject) -> CGSize = { str, attr in
      guard
        let item = UIMenuController.shared.findImageItemByTitle(str as String),
        let image = item.imageBox.value
      else {
        return origIMPC(str, selector, attr)
      }

      return image.size
    }
    
    setNewIMPWithBlock(block, forSelector: selector, toClass: self)
  }
  
}

// MARK: Helper to find first responder
// Source: http://stackoverflow.com/a/14135456/395213
private var _currentFirstResponder: UIResponder? = nil

private extension UIResponder {
  
  static var mik_firstResponder: UIResponder? {
    _currentFirstResponder = nil
    UIApplication.shared.sendAction(#selector(mik_findFirstResponder(_:)), to: nil, from: nil, for: nil)
    return _currentFirstResponder
  }
  
  @objc func mik_findFirstResponder(_ sender: AnyObject) {
    _currentFirstResponder = self
  }
  
}
