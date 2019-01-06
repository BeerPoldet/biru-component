//
//  ComponentC.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 29/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

//public typealias NoStateC = ()
public protocol StateC {
  init()
}
public struct NoStateC: StateC {
  public init() {}
}

public struct ElementC {
  var kind: KindC
  var key: String? = nil
  
  init(kind: KindC, key: String? = nil) {
    self.kind = kind
    self.key = key
  }
}

public indirect enum KindC {
  case root(element: ElementC, root: Any)
  case empty
  case label(text: String)
  case stack(children: [ElementC])
  case component(type: InternalComponentC.Type)
}

public protocol InternalComponentC {
  init()
  func render() -> ElementC?
  
  var update: (Any) -> () { get set }
  
  func updateState(_ state: Any)
  var internalState: StateC { get set }
  func componentDidMount()
  func componentWillUnmount()
}

open class ComponentC<State: StateC>: InternalComponentC {
  
  public var state: State
  
  public var internalState: StateC {
    get {
      return state
    }
    set {
      if let newValue = newValue as? State {
        state = newValue
      }
    }
  }
  
  required public init() {
    self.state = State()
  }
  open func componentDidMount() {}
  open func componentWillUnmount() {}
  
  open func render() -> ElementC? {
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

public func label(text: String, key: String? = nil) -> ElementC {
  return ElementC(kind: .label(text: text), key: key)
}

public func stack(children: [ElementC], key: String? = nil) -> ElementC {
  return ElementC(kind: .stack(children: children), key: key)
}

public func createElement(_ componentType: InternalComponentC.Type, key: String? = nil) -> ElementC {
  return ElementC(kind: .component(type: componentType), key: key)
}

public class RendererC {
  var rootContainer: FiberC?
  
  public init() {}
  
  public func render(element: ElementC, root: UIView) {
    if rootContainer == nil {
      rootContainer = Reconciler.createContainer(element: element, root: root)
    }
    
    if let rootContainer = rootContainer {
      Reconciler.updateContainer(
        element: element,
        rootContainer: rootContainer
      )
    }
  }
}

public enum Reconciler {
  public static func createContainer(element: ElementC, root: UIView) -> FiberC {
    return createFiber(
      element: ElementC(kind: .root(element: element, root: root)),
      parent: nil
    )
  }
  
  static func updateContainer(
    element: ElementC,
    rootContainer: FiberC
  ) {
    updateFiber(
      element: ElementC(kind: .root(element: element, root: rootContainer.stateNode!)),
      fiber: rootContainer
    )
  }
  
  private static func updateFiber(
    element: ElementC,
    fiber: FiberC
  ) {
    print("Update Fiber", element.kind, fiber.kind)
    switch element.kind {
    case .root(let element, _):
      updateFiber(element: element, fiber: fiber.child!)
    case .empty:
      return
    case .label(let text):
      let label = fiber.stateNode as! UILabel
      label.text = text
      label.sizeToFit()
      if !fiber.isAppendedToParent {
        appendChild(fiber, to: fiber.parent)
      }
    case .stack(let children):
      let (updates, removes, adds) = diff(elements: children, fibers: fiber.children)
      var updatedFibers = [FiberC?](repeating: nil, count: children.count)
      print("----- stack -----")
      print("----- removes -----")
      print(removes)
      print("----- updates -----")
      print(updates)
      print("----- add -----")
      print(adds)
      removes.forEach { (removingFiber) in
        let stackView = (fiber.stateNode as! UIStackView)
        if let childView = removingFiber.view {
          stackView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: stackView.frame.height - childView.frame.height))
        }
        removeFiber(removingFiber)
      }
      adds.forEach { (element, idx) in
        let fiber = createFiber(element: element, parent: fiber)
        updateFiber(element: element, fiber: fiber)
        updatedFibers[idx] = fiber
      }
      updates.forEach { (element, fiber, idx) in
        updateFiber(element: element, fiber: fiber)
        updatedFibers[idx] = fiber
      }
      fiber.children = updatedFibers.compactMap { $0 }
      
      if !fiber.isAppendedToParent {
        appendChild(fiber, to: fiber.parent)
      }
    case .component(_):
      let component = fiber.stateNode! as! InternalComponentC
      let childElement = component.performRender()
      print("*********** ", fiber.kind)
      print("*********** ", fiber.parent)
      if let childFiber = fiber.child {
//        print("Updating child", childElement, childFiber.kind)
        if isSameKind(childElement, childFiber) {
          updateFiber(element: childElement, fiber: childFiber)
        } else {
          removeFiber(childFiber)
        }
      }
      
      if fiber.child == nil {
        print("======== removeFiber()", fiber.child?.kind)
        let newChildFiber = createFiber(element: childElement, parent: fiber)
        fiber.child = newChildFiber
        print("======== Removing child", fiber.child?.kind)
        updateFiber(element: childElement, fiber: newChildFiber)
      }
      
    }
  }
  
  private static func removeFiber(_ fiber: FiberC) {
    switch fiber.kind {
    case .root:
      break
    case .empty:
      break
    case .label:
      fiber.view?.removeFromSuperview()
    case .stack:
      fiber.view?.removeFromSuperview()
    case .component:
      var component = (fiber.stateNode as! InternalComponentC)
      component.componentWillUnmount()
      component.update = { _ in }
      removeFiber(fiber.child!)
    }
    
    if fiber.kind != .root {
      fiber.clearChildren()
      fiber.parent!.clearChildren()
      fiber.parent = nil
    }
  }
  
  typealias ElementUpdate = (ElementC, FiberC, Int)
  typealias ElementAdd = (ElementC, Int)
  
  private static func diff(
    elements: [ElementC],
    fibers: [FiberC]
  ) -> ([ElementUpdate], [FiberC], [ElementAdd]) {
    let updates = findUpdates(elements: elements, fibers: fibers)
    let removes = findRemoves(elements: elements, fibers: fibers)
    let adds = findAdds(elements: elements, fibers: fibers)
    return (updates, removes, adds)
  }
  
  private static func findUpdates(elements: [ElementC], fibers: [FiberC]) -> [ElementUpdate] {
    return elements.enumerated().compactMap({ enumerate -> ElementUpdate? in
      let (elementIndex, element) = enumerate
      if let elementUpdateByKey = shouldUpdateByKey(element: element, elementIndex: elementIndex, fibers: fibers) {
        return elementUpdateByKey
      } else if let elementUpdateByKind = shouldUpdateByKind(element: element, elementIndex: elementIndex, fibers: fibers) {
        return elementUpdateByKind
      }
      return nil
      
    })
  }
  
  private static func findAdds(elements: [ElementC], fibers: [FiberC]) -> [ElementAdd] {
    return elements.enumerated().compactMap({ enumerate -> ElementAdd? in
      let (elementIndex, element) = enumerate
      if shouldUpdateByKey(element: element, elementIndex: elementIndex, fibers: fibers) != nil {
        return nil
      } else if shouldUpdateByKind(element: element, elementIndex: elementIndex, fibers: fibers) != nil {
        return nil
      }
      
      return (element, elementIndex)
    })
  }
  
  private static func findRemoves(elements: [ElementC], fibers: [FiberC]) -> [FiberC] {
    return fibers.enumerated().filter({ fiberEnumerated in
      let (fiberIndex, fiber) = fiberEnumerated
      if elements.contains(where: { element in
        shouldUpdateByKey(element: element, fiber: fiber)
      }) {
        return false
      } else if elements.enumerated().contains(where: { (elementIndex, element) in
        shouldUpdateByKind(element: element, elementIndex: elementIndex, fiber: fiber, fiberIndex: fiberIndex)
      }) {
        return false
      }
      return true
    }).map { $0.1 }
  }
  
  private static func shouldUpdateByKey(element: ElementC, elementIndex: Int, fibers: [FiberC]) -> ElementUpdate? {
    if let fiber = fibers.enumerated().first(where: { (fiberIndex, fiber) in
      shouldUpdateByKey(element: element, fiber: fiber)
    })?.element {
      return (element, fiber, elementIndex)
    }
    return nil
  }
  
  private static func shouldUpdateByKind(element: ElementC, elementIndex: Int, fibers: [FiberC]) -> ElementUpdate? {
    if let fiber = fibers.enumerated().first(where: { (fiberIndex, fiber) in
      shouldUpdateByKind(element: element, elementIndex: elementIndex, fiber: fiber, fiberIndex: fiberIndex)
    })?.element {
      return (element, fiber, elementIndex)
    }
    return nil
  }
  
  private static func shouldUpdateByKey(
    element: ElementC,
    fiber: FiberC
  ) -> Bool {
    return isSameKind(element, fiber) && element.key == fiber.key && element.key != nil
  }
  
  private static func shouldUpdateByKind(
    element: ElementC,
    elementIndex: Int,
    fiber: FiberC,
    fiberIndex: Int
  ) -> Bool {
    return isSameKind(element, fiber) && elementIndex == fiberIndex
  }
  
  private static func appendChild(_ child: FiberC, to parent: FiberC?) {
    guard let parent = parent else { return }
    print("appendChild")
    print(parent.stateNode, child.stateNode)
    switch parent.kind {
    case .component:
      appendChild(child, to: parent.parent)
      if !parent.isAppendedToParent {
        (parent.stateNode! as! InternalComponentC).componentDidMount()
      }
      parent.isAppendedToParent = true
    case .root:
      (parent.stateNode! as! UIView).addSubview(child.stateNode! as! UIView)
      child.isAppendedToParent = true
    case .empty, .label:
      return
    case .stack:
      let stackView = parent.stateNode! as! UIStackView
      let childView = child.stateNode! as! UIView
      stackView.addArrangedSubview(childView)
      stackView.axis = .vertical
      stackView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: stackView.frame.height + childView.frame.height))
      child.isAppendedToParent = true
    }
  }
  
  private static func createFiber(element: ElementC, parent: FiberC?) -> FiberC {
    switch element.kind {
    case .root(let element, let root):
      let root = FiberC(kind: .root, stateNode: root, key: element.key)
      root.child = createFiber(element: element, parent: root)
      return root
    case .empty:
      return FiberC(kind: .empty, parent: parent, key: element.key)
    case .label(let text):
      return FiberC(kind: .label, props: text, stateNode: UILabel(), parent: parent, key: element.key)
    case .stack(let children):
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.distribution = .fill
      let fiber = FiberC(kind: .stack, stateNode: UIStackView(), parent: parent, key: element.key)
      fiber.children = children.map({ createFiber(element: $0, parent: fiber) })
      return fiber
    case .component(let type):
      var component = type.init()
      let renderedElement: ElementC = component.performRender()
      let fiber = FiberC(kind: .component, props: nil, stateNode: component, parent: parent, key: element.key)
      let child = createFiber(element: renderedElement, parent: fiber)
      component.update = { state in
        component.updateState(state)
        updateFiber(element: element, fiber: fiber)
      }
      fiber.child = child
      return fiber
    }
  }
}

enum FiberKindC {
  case root
  case empty
  case label
  case stack
  case component
}

public class FiberC {
  var kind: FiberKindC
  var props: Any?
  var stateNode: Any?
  weak var parent: FiberC?
  var children: [FiberC]
  var isAppendedToParent: Bool = false
  var child: FiberC? {
    get { return children.first }
    set {
      if let newValue = newValue {
        children.append(newValue)
      }
    }
  }
  var key: String?

  init(
    kind: FiberKindC,
    props: Any? = nil,
    stateNode: Any? = nil,
    parent: FiberC? = nil,
    children: [FiberC] = [],
    key: String? = nil
  ) {
    self.kind = kind
    self.props = props
    self.stateNode = stateNode
    self.parent = parent
    self.children = children
    self.key = key
  }
  
  func clearChildren() {
    children = []
  }
}

extension FiberC {
  var view: UIView? {
    return stateNode as? UIView
  }
}

extension InternalComponentC {
  func performRender() -> ElementC {
    return self.render() ?? ElementC.init(kind: .empty)
  }
}

func isSameKind(_ element: ElementC, _ fiber: FiberC) -> Bool {
  switch (element.kind, fiber.kind) {
  case (.root, .root): return true
  case (.empty, .empty): return true
  case (.label, .label): return true
  case (.stack, .stack): return true
  case (.component, .component): return true
  default: return false
  }
}

extension Array {
  func get(index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
