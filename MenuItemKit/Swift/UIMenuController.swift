//
//  UIMenuController.swift
//  MenuItemKit
//
//  Created by CHEN Xian-an on 25/02/2018.
//  Copyright © 2018 lazyapps. All rights reserved.
//

import UIKit

public typealias ActionFilter = (_ action: Selector, _ default: Bool) -> Bool

public extension UIMenuController {
  @objc(mik_installToResponder:shouldShowForAction:)
  static func installTo(responder: UIResponder, shouldShowForAction: @escaping ActionFilter = { $1 }) {
    swizzle(responder, shouldShowForAction: shouldShowForAction)
  }
}
