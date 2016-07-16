//
//  MenuItemKitTests.swift
//  MenuItemKitTests
//
//  Created by CHEN Xian’an on 1/16/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import XCTest
@testable import MenuItemKit

class MenuItemKitTests: XCTestCase {
    
  func testConvenienceInit() {
    let blockItem = UIMenuItem(title: "A", action: { _ in })
    XCTAssertTrue(NSStringFromSelector(blockItem.action).hasPrefix(blockIdentifierPrefix))
    let imageItem = UIMenuItem(title: "A", image: UIImage(), action: { _ in })
    XCTAssertTrue(NSStringFromSelector(imageItem.action).hasPrefix(blockIdentifierPrefix))
  }

}
