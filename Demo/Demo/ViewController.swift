//
//  ViewController.swift
//  Demo
//
//  Created by CHEN Xian’an on 1/16/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

import UIKit
import MenuItemKit

class ViewController: UIViewController {

  @IBOutlet var button: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    button.addTarget(self, action: #selector(self.tapButton(_:)), for: .touchUpInside)
  }

  @objc func tapButton(_ sender: AnyObject?) {
    let controller = UIMenuController.shared
    let textItem = UIMenuItem(title: "Text") { [weak self] _ in
      self?.showAlertWithTitle("text item tapped")
    }
    
    let image = UIImage(named: "Image")
    let imageItem = UIMenuItem(title: "Image", image: image) { [weak self] _ in
      self?.showAlertWithTitle("image item tapped")
    }

    let colorImage = UIImage(named: "ColorImage")
    let colorImageItem = UIMenuItem(title: "Image", image: colorImage) { [weak self] _ in
      self?.showAlertWithTitle("color image item tapped")
    }
    
    let nextItem = UIMenuItem(title: "Show More Items...") { _ in
      let action: MenuItemAction = { [weak self] in self?.showAlertWithTitle($0.title + " tapped") }
      let item1 = UIMenuItem(title: "1", action: action)
      let item2 = UIMenuItem(title: "2", action: action)
      let item3 = UIMenuItem(title: "3", action: action)
      controller.menuItems = [item1, item2, item3]
      controller.setMenuVisible(true, animated: true)
    }
    
    controller.menuItems = [textItem, imageItem, colorImageItem, nextItem]
    controller.setTargetRect(button.bounds, in: button)
    controller.setMenuVisible(true, animated: true)
  }

  func showAlertWithTitle(_ title: String) {
    let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in }))
    present(alertVC, animated: true, completion: nil)
  }

}
