//
//  ViewController.swift
//  AutoPopupMenuControllerDemo
//
//  Created by CHEN Xian-an on 25/02/2018.
//  Copyright © 2018 Neo Xian-an CHEN. All rights reserved.
//

import UIKit
import MenuItemKit

class ViewController: UIViewController {
  @IBOutlet weak var textView: UITextView!

  var showsColorItem = false

  override func viewDidLoad() {
    super.viewDidLoad()
    let controller = UIMenuController.shared
    let textItem = UIMenuItem(title: "Toggle Color Item") { [weak self] _ in
      self?.showAlertWithTitle("Toggle item tapped")
      self?.showsColorItem = !(self?.showsColorItem ?? true)
    }

    let image = UIImage(named: "Image")
    let imageItem = UIMenuItem(title: "Image", image: image) { [weak self] _ in
      self?.showAlertWithTitle("image item tapped")
    }

    let colorImage = UIImage(named: "ColorImage")
    let colorImageItem = UIMenuItem(title: "ColorImage", image: colorImage) { [weak self] _ in
      self?.showAlertWithTitle("color image item tapped")
    }

    controller.menuItems = [textItem, imageItem, colorImageItem]
    UIMenuController.installTo(responder: textView) { action, `default` in
      if action == colorImageItem.action { return self.showsColorItem }
      return UIMenuItem.isMenuItemKitSelector(action)
    }

    textView.becomeFirstResponder()
  }

  func showAlertWithTitle(_ title: String) {
    let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in }))
    present(alertVC, animated: true, completion: nil)
  }
}
