//
//  UIMenuController.swift
//  MenuItemKit
//
//  Created by CHEN Xian-an on 25/02/2018.
//  Copyright © 2018 lazyapps. All rights reserved.
//

import UIKit

public extension UIMenuController {
  @objc(mik_installToResponder:shouldShowForAction:)
  static func installTo(responder: UIResponder, shouldShowForAction: @escaping (_ action: Selector, _ default: Bool) -> Bool = { $1 }) {
    swizzle(class: type(of: responder), shouldShowForAction: shouldShowForAction)
  }
}
