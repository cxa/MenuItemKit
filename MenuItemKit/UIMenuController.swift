//
//  UIMenuController.swift
//  MenuItemKit
//
//  Created by CHEN Xian-an on 25/02/2018.
//  Copyright © 2018 lazyapps. All rights reserved.
//

import UIKit

public extension UIMenuController {
  @objc(mik_installToViewController:)
  static func installToViewController(_ viewController: UIViewController) {
    swizzle(class: type(of: viewController))
  }
}
