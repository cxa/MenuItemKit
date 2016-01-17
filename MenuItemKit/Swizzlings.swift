//
//  UIMenuController.swift
//  MenuItemKit
//
//  Created by CHEN Xian’an on 1/17/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

public extension UIMenuController {
  
  override class func initialize() {
    if true {
      let selector: Selector = "setMenuItems:"
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, AnyObject) -> ()
      let origIMPC = unsafeBitCast(origIMP, IMPType.self)
      let block: @convention(block) (AnyObject, AnyObject) -> () = {
        if let firstResp = UIResponder.mik_firstResponder {
          swizzleClass(firstResp.dynamicType)
        }
        
        origIMPC($0, selector, $1)
      }
      
      let newIMP = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(newIMP, forSelector: selector, toClass: self)
    }
    
    if true {
      let selector: Selector = "setTargetRect:inView:"
      let origIMP = class_getMethodImplementation(self, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, CGRect, UIView) -> ()
      let origIMPC = unsafeBitCast(origIMP, IMPType.self)
      let block: @convention(block) (AnyObject, CGRect, UIView) -> () = {
        if let firstResp = UIResponder.mik_firstResponder {
          swizzleClass(firstResp.dynamicType)
        } else {
          swizzleClass($2.dynamicType)
          // Must call `becomeFirstResponder` since there's no firstResponder yet
          $2.becomeFirstResponder()
        }
        
        origIMPC($0, selector, $1, $2)
      }
      
      let newIMP = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(newIMP, forSelector: selector, toClass: self)
    }
  }
}

public extension UILabel {
  
  override class func initialize() {
    let selector: Selector = "drawTextInRect:"
    let origIMP = class_getMethodImplementation(self, selector)
    typealias IMPType = @convention(c) (UILabel, Selector, CGRect) -> ()
    let origIMPC = unsafeBitCast(origIMP, IMPType.self)
    let block: @convention(block) (UILabel, CGRect) -> () = { label, rect in
      guard
        let text = label.text,
        let item = UIMenuController.sharedMenuController().findMenuItemBySelector(text)
        else {
          origIMPC(label, selector, rect)
          return
      }
      
      let image = item.imageBox.value
      let point = CGPoint(x: (label.bounds.width  - (image?.size.width ?? 0)) / 2,
        y: (label.bounds.height - (image?.size.height ?? 0)) / 2)
      image?.drawAtPoint(point)
    }
    
    let newIMP = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
    setNewIMP(newIMP, forSelector: selector, toClass: self)
  }
  
}

public extension NSString {
  
  override class func initialize() {
    let selector: Selector = "sizeWithAttributes:"
    let origIMP = class_getMethodImplementation(self, selector)
    typealias IMPType = @convention(c) (NSString, Selector, AnyObject) -> CGSize
    let origIMPC = unsafeBitCast(origIMP, IMPType.self)
    let block: @convention(block) (NSString, AnyObject) -> CGSize = { str, attr in
      let selStr = str as String
      if isMenuItemKitSelector(selStr),
        let item = UIMenuController.sharedMenuController().findMenuItemBySelector(selStr)
      {
        return item.imageBox.value?.size ?? CGSizeZero
      }
      
      return origIMPC(str, selector, attr)
    }
    
    let newIMP = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
    setNewIMP(newIMP, forSelector: selector, toClass: self)
  }
  
}

extension UIMenuController {
  
  func findMenuItemBySelector(selector: Selector?) -> UIMenuItem? {
    guard let sel = selector else { return nil }
    for item in menuItems ?? [] where sel_isEqual(item.action, sel) {
      return item
    }
    
    return nil
  }
  
  func findMenuItemBySelector(selector: String?) -> UIMenuItem? {
    guard let selStr = selector else { return nil }
    return findMenuItemBySelector(NSSelectorFromString(selStr))
  }
  
}

private extension UIMenuController {
  
  // This is inspired by https://github.com/steipete/PSMenuItem
  static func swizzleClass(klass: AnyClass) {
    objc_sync_enter(klass)
    let key: StaticString = __FUNCTION__
    guard objc_getAssociatedObject(klass, key.utf8Start) == nil else { return }
    
    if true {
      // swizzle canBecomeFirstResponder
      let selector: Selector = "canBecomeFirstResponder"
      let block: @convention(block) (AnyObject) -> Bool = { _ in true }
      let imp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(imp, forSelector: selector, toClass: klass)
    }
    
    if true {
      // swizzle canPerformAction:withSender:
      let selector: Selector = "canPerformAction:withSender:"
      let origIMP = class_getMethodImplementation(klass, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, Selector, AnyObject) -> Bool
      let origIMPC = unsafeBitCast(origIMP, IMPType.self)
      let block: @convention(block) (AnyObject, Selector, AnyObject) -> Bool = {
        return isMenuItemKitSelector($1) ? true : origIMPC($0, selector, $1, $2)
      }
      
      let imp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(imp, forSelector: selector, toClass: klass)
    }
    
    if true {
      // swizzle methodSignatureForSelector:
      let selector: Selector = "methodSignatureForSelector:"
      let origIMP = class_getMethodImplementation(klass, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, Selector) -> AnyObject
      let origIMPC = unsafeBitCast(origIMP, IMPType.self)
      let block: @convention(block) (AnyObject, Selector) -> AnyObject = {
        if isMenuItemKitSelector($1) {
          // `NSMethodSignature` is not allowed in Swift, this is a workaround
          return methodSignatureForSelector("_mik_aDummyClassFuncForFakeSignature:")
        }
        
        return origIMPC($0, selector, $1)
      }
      
      let imp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(imp, forSelector: selector, toClass: klass)
    }
    
    if true {
      // swizzle forwardInvocation:
      // `NSInvocation` is not allowed in Swift, so we just use AnyObject
      let selector: Selector = "forwardInvocation:"
      let origIMP = class_getMethodImplementation(klass, selector)
      typealias IMPType = @convention(c) (AnyObject, Selector, AnyObject) -> AnyObject
      let origIMPC = unsafeBitCast(origIMP, IMPType.self)
      let block: @convention(block) (AnyObject, AnyObject) -> () = {
        if isMenuItemKitSelector($1.selector) {
          guard let item = sharedMenuController().findMenuItemBySelector($1.selector) else { return }
          item.handlerBox.value?(item)
        } else {
          origIMPC($0, selector, $1)
        }
      }
      
      let imp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
      setNewIMP(imp, forSelector: selector, toClass: klass)
    }
    
    objc_setAssociatedObject(klass, key.utf8Start, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    objc_sync_exit(klass)
  }
  
}

private extension NSObject {
  
  @objc class func _mik_aDummyClassFuncForFakeSignature(sender: AnyObject) {}
  
}

// MARK: Helper to find first responder
// Source: http://stackoverflow.com/a/14135456/395213
private var _currentFirstResponder: UIResponder? = nil

private extension UIResponder {
  
  static var mik_firstResponder: UIResponder? {
    _currentFirstResponder = nil
    UIApplication.sharedApplication().sendAction("mik_findFirstResponder:", to: nil, from: nil, forEvent: nil)
    return _currentFirstResponder
  }
  
  @objc func mik_findFirstResponder(sender: AnyObject) {
    _currentFirstResponder = self
  }
  
}
