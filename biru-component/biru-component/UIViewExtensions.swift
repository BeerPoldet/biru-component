//
//  UIView+UITapGestureRecognizer.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 9/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit

extension UIView {

  // In order to create computed properties for extensions, we need a key to
  // store and access the stored property
  fileprivate struct AssociatedObjectKeys {
    static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
  }

  fileprivate typealias Action = (() -> Void)?

  // Set our computed property type to a closure
  fileprivate var tapGestureRecognizerAction: Action? {
    set {
      if let newValue = newValue {
        // Computed properties get stored as associated objects
        objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      }
    }
    get {
      let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
      return tapGestureRecognizerActionInstance
    }
  }

  // This is the meat of the sauce, here we create the tap gesture recognizer and
  // store the closure the user passed to us in the associated object we declared above
  public func addTapGestureRecognizer(action: (() -> Void)?) {
    self.isUserInteractionEnabled = true
    self.tapGestureRecognizerAction = action
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    self.addGestureRecognizer(tapGestureRecognizer)
  }

  // Every time the user taps on the UIImageView, this function gets called,
  // which triggers the closure we stored
  @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
    if let action = self.tapGestureRecognizerAction {
      action?()
    } else {
      print("no action")
    }
  }

}

extension UITextField {

  fileprivate struct AssociatedObjectKeys {
    static var textChange = "MediaViewerAssociatedObjectKey_mediaViewer"
  }

  public typealias TextChangeAction = (String) -> Void

  // Set our computed property type to a closure
  fileprivate var handleTextChangeAction: TextChangeAction? {
    set {
      if let newValue = newValue {
        // Computed properties get stored as associated objects
        objc_setAssociatedObject(self, &AssociatedObjectKeys.textChange, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      }
    }
    get {
      return objc_getAssociatedObject(self, &AssociatedObjectKeys.textChange) as? TextChangeAction
    }
  }

  public func handleTextChange(_ action: @escaping TextChangeAction) {
    self.handleTextChangeAction = action
    self.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
  }

  @objc private func didChangeText(_ sender: UITextField) {
    if let action = self.handleTextChangeAction {
      action(sender.text!)
    }
  }
}

