//
//  ComponentA.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 15/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

public protocol ComponentA {
  init()
  func render() -> ElementA?
  
  var update: (Any) -> () { get set }
  
  var initialState: Any? { get }
  func updateState(_ state: Any)
}

open class ComponentB<State>: ComponentA {
  
  public var initialState: Any? {
    return state
  }
  
  public var state: State!
  
  required public init() {}
  
  open func render() -> ElementA? {
    return nil
  }
  
  public func setState(_ newState: State) {
    update(newState)
  }
  
  public var update: (Any) -> () = { _ in }
  
  public func updateState(_ state: Any) {
    self.state = (state as! State)
  }
}

public class Tree {
  let e: ElementA
  let children: [Tree]
  let key: UUID
  
  init (e: ElementA, children: [Tree], key: UUID) {
    self.e = e
    self.children = children
    self.key = key
  }
  
  static func from(element: ElementA) -> Tree {
    switch element.kind {
    case .empty:
      return Tree(e: BiruA.empty(), children: [], key: UUID())
    case .label:
      return Tree(e: element, children: [], key: UUID())
    case let .component(type):
      return from(element: type.init().render() ?? BiruA.empty())
    }
  }
  
  func toString() -> String {
    return "\(e.kind):\(key) " + children.map({ $0.toString() }).joined(separator: ", ")
  }
}

class Fiber {
  var states: [UUID: Any] = [:]
  let callback: () -> ()
  
  init(callback: @escaping () -> ()) {
    self.callback = callback
  }
  
  public func putState(component: ComponentA, forKey key: UUID) {
    let state = states[key]
    if let state = state {
      component.updateState(state)
    }
  }
  
  func createUpdateState(key: UUID) -> (_ state: Any) -> () {
    return { [unowned self] state in
      print(self.states)
      self.states[key] = state
      self.callback()
    }
  }
}

public class RendererA {
  let rootElement: ElementA
  let rootView: UIView
  var rootTree: Tree
  lazy var fiber = Fiber(callback: self.update)
  
  init(rootElement: ElementA, rootView: UIView) {
    self.rootElement = rootElement
    self.rootView = rootView
    self.rootTree = Tree.from(element: rootElement)
  }
  
  func update() {
    // add to queue
    let layout = render(element: rootElement)
    layout.arrangement().makeViews(in: rootView)
  }
  
  func render(element: ElementA) -> Layout {
    self.rootTree = Tree.from(element: element)
    print(rootTree.toString())
    switch element.kind {
    case .empty:
      return RendererA.createEmpty()
    case .component(let type):
      let key = UUID()
      var component = type.init()
      fiber.putState(component: component, forKey: key)
      component.update = fiber.createUpdateState(key: key)
      return render(element: component.render() ?? BiruA.label(text: "NONONO"))
    case let .label(text, onTap):
      return RendererA.createLabel(text: text, onTap: onTap)
    }
  }
  
  private static func createLabel(
    text: String,
    onTap: (() -> ())?
  ) -> LabelLayout<UILabel> {
    let labelLayout = LabelLayout(text: text, config: {
      $0.addTapGestureRecognizer(action: onTap)
    })
    return labelLayout
  }
  
  private static func createEmpty() -> Layout {
    return SizeLayout(size: CGSize.zero)
  }
}

public enum BiruA {
  public static func createElement<C: ComponentA>(
    component type: C.Type
  ) -> ElementA {
    return ElementA(kind: .component(type: type))
  }
  
  public static func render(element: ElementA, into container: UIView) -> RendererA {
    let renderer = RendererA(rootElement: element, rootView: container)
    renderer.update()
    return renderer
  }
  
  public static func label(text: String, onTap: (() -> ())? = nil) -> ElementA {
    return ElementA(kind: .label(text: text, onTap: onTap))
  }
  
  public static func empty() -> ElementA {
    return ElementA(kind: .empty)
  }
}

public class ElementA {
  enum Kind {
    case empty
    case label(text: String, onTap: (() -> ())?)
    case component(type: ComponentA.Type)
  }
  let kind: Kind
  
  init(kind: Kind) {
    self.kind = kind
  }
}
