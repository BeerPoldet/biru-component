//
//  Created by Poldet Assanangkornchai on 8/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

public protocol ElmState {}
public struct NoState: ElmState {}

public protocol ElmAction {}
public struct NoAction: ElmAction {}

public protocol ComponentProtocol: AnyObject {
  func render() -> ComponentProtocol?
  
  var rerender: (() -> ())! { get set }
}

public class BaseComponent: StatelessComponent {
  public func toLayout() -> Layout? {
    return nil
  }
  
  public var rerender: (() -> ())!
}

extension BaseComponent {
  public func render() -> ComponentProtocol? {
    return nil
  }
}

public protocol StatelessComponent: Component where State == NoState, Action == NoAction {
  func render() -> ComponentProtocol?
}

extension StatelessComponent {
  public var state: NoState {
    get { return NoState() }
    set {}
  }
  
  public func reduce(state: NoState, action: NoAction) -> NoState {
    return NoState()
  }
  
  public func render(state: NoState, dispatch: @escaping (NoAction) -> ()) -> ComponentProtocol? {
    return render()
  }
}

public protocol Component: ComponentProtocol {
  associatedtype State
  associatedtype Action
  
  var state: State { get set }
  
  func reduce(state: State, action: Action) -> State
  func render(state: State, dispatch: @escaping (Action) -> ()) -> ComponentProtocol?
}

extension Component {
  
  func createDispatch(then: @escaping () -> ()) -> (Action) -> () {
    return { action in
      let newState = self.reduce(state: self.state, action: action)
      self.state = newState
      print("dispatched state \(self.state)")
      then()
    }
  }
  
  public func render() -> ComponentProtocol? {
    if let rerender = rerender {
      print("rendering state \(self.state)")
      return render(state: state, dispatch: createDispatch(then: rerender))
    }
    return nil
  }
}

func takeF<S, A, C: Component>(component: C) where C.State == S, C.Action == A {
  
}


//class World: StatelessComponent {
//  func render<C>() -> C where C : Component {
//    return BaseComponent()
//  }
//}

public class Label: BaseComponent {
  let text: String
  let onTap: (() -> ())?
  public init(text: String, onTap: (() -> ())? = nil) {
    self.text = text
    self.onTap = onTap
  }
  
  public override func toLayout() -> Layout? {
    return LabelLayout(text: self.text, config: {
      $0.addTapGestureRecognizer(action: self.onTap)
    })
  }
}

public class StackLayout: BaseComponent {
  let children: [ComponentProtocol]
  public init(children: [ComponentProtocol]) {
    self.children = children
  }
  
  public override func toLayout() -> Layout? {
    return LayoutKit.StackLayout(
      axis: Axis.horizontal,
      sublayouts: children.map({ $0.renderView(rerender: self.rerender) })
    )
  }
}

public enum X {
  public static func render(component: ComponentProtocol, into container: UIView) {
    component.renderView(rerender: { render(component: component, into: container) })
      .arrangement()
      .makeViews(in: container)
  }
}

extension ComponentProtocol {
  
}

extension ComponentProtocol {
  public func renderView(rerender: @escaping (() -> ())) -> Layout {
    print("--- renderView", self)
    self.rerender = rerender
    if let baseComponent = self as? BaseComponent, let layout = baseComponent.toLayout() {
      print("hi!",baseComponent.rerender)
      return layout
    }
    
    let component = self.render()

    return component?.renderView(rerender: rerender) ?? LabelLayout(text: "NULL")
    
  }
  
//  private func createLabel(text: String) -> LabelLayout<UILabel> {
//    let labelLayout = LabelLayout(text: text)
//    return labelLayout
//  }
//
//  private func createStacklayout<C: Component>(children: [C], axis: Axis) -> LayoutKit.StackLayout<UIView> {
//    func mapAxis(_ axis: Axis) -> LayoutKit.Axis {
//      switch axis {
//      case .horizontal: return .horizontal
//      case .vertical: return .vertical
//      }
//    }
//    return LayoutKit.StackLayout(
//      axis: mapAxis(axis),
//      sublayouts: children.map({ $0.render(rerender: {}) })
//    )
//  }
}

//public protocol ComponentX {
//  static func base(element: Element) -> Self
//  static func stateless(render: @escaping () -> Self) -> Self
//  static func stateful<State, Action>(
//    initialState: State,
//    reduce: @escaping (State, Action) -> State,
//    render: @escaping (State, (Action) -> ()) -> Self
//  ) -> Self
//}
//
//public struct ComponentRenderer {
//  public typealias Callback = () -> ()
//  public let render: (@escaping Callback) -> Layout
//}
//
//public enum E {
//  case label(text: String)
//  case stackLayout(children: [Component], axis: Axis)
//}
//
//public enum Virtual {
//  case baseComponent(E)
//  case statelessComponent(render: () -> Virtual)
//  case statefulComponent(AnyStateful)
//}
//
//public class AnyStateful {
//  var state: Any
//  let reduce: (Any, Any) -> Any
//  let render: (Any, (Any) -> ()) -> Component
//  init(initialState: Any, reduce: Any, render: Any) {
//    self.state = initialState
//    self.reduce = reduce as! (Any, Any) -> Any
//    self.render = render as! (Any, (Any) -> ()) -> Component
//  }
//}
//
//extension AnyStateful {
//  func createDispatch(then: @escaping () -> ()) -> (_ action: Any) -> () {
//    return { [unowned self] action in
//      let newState = self.reduce(self.state, action)
//      self.state = newState
//      then()
//    }
//  }
//}
//
//public enum Component {
//  case base(element: E)
//  case stateless(render: () -> Component)
//  case stateful(handler: AnyStateful)
//}
//
//public func label(text: String) -> Component {
//  return .base(element: .label(text: text))
//}
//
//public enum Axis { case vertical, horizontal }
//
//public func stackLayout(children: [Component], axis: Axis = .vertical) -> Component {
//  return .base(
//    element: .stackLayout(children: children, axis: axis)
//  )
//}
//
//public func createStatelessComponent(_ render: @escaping () -> Component) -> Component {
//  return .stateless(render: render)
//}
//
//
//public func createStatefulComponent<State, Action>(
//  initialState: State,
//  reduce: @escaping (State, Action) -> State,
//  render: @escaping (State, (Action) -> ()) -> Component
//) -> Component {
//  return .stateful(handler: AnyStateful(initialState: initialState, reduce: reduce, render: render))
//}
//
//protocol Z {}
//
//struct X: Z {}
//
//struct Test<State, Action>: Z {
//  let baseElement: Element?
//
//  var state: State?
//  let statefulRender: ((State, (Action) -> ()) -> Z)?
//  let reduce: ((State, Action) -> State)?
//
//  let statelessRender: (() -> Test)?
//}
//
//extension X {
//  func something() {
//    print(self)
//  }
//}
//
//extension Test {
//  func something() {
//    print(self)
//  }
//}
//
//public func main() {
//  Test<Int, Any>(
//    baseElement: nil,
//    state: 1,
//    statefulRender: { (state, dispatch) in X()},
//    reduce: { state, _ in state }, statelessRender: nil
//  ).something()
//}

//extension Test: Component {
//  static func base(element: Element) -> Test<State, Action> {
//    return Test(baseElement: element, state: nil, statefulRender: nil, reduce: nil, statelessRender: nil)
//  }
//
//  static func stateless(render: @escaping () -> Test<State, Action>) -> Test<State, Action> {
//    return Test(baseElement: nil, state: nil, statefulRender: nil, reduce: nil, statelessRender: render)
//  }
//
//  static func stateful<State, Action>(
//    initialState: State,
//    reduce: @escaping (State, Action) -> State,
//    render: @escaping (State, (Action) -> ()) -> Test<State, Action>
//    ) -> Test<State, Action> {
//    return Test(baseElement: nil, state: Optional<State>(initialState), statefulRender: render, reduce: reduce, statelessRender: nil)
//  }
//}

//extension ComponentRenderer: ComponentX {
//
//  public static func base(element: Element) -> ComponentRenderer {
//    return ComponentRenderer { _ in
//      element.render()
//    }
//  }
//
//  public static func stateless(render: @escaping () -> ComponentRenderer) -> ComponentRenderer {
//    return ComponentRenderer { _ in
//      Elm.createElement(component: render()).render()
//    }
//  }
//
//  static func stateful<State, Action>(
//    initialState: State,
//    reduce: @escaping (State, Action) -> State,
//    render: @escaping (State, (Action) -> ()) -> ComponentRenderer,
//    setState: (State) -> ()
//  ) -> ComponentRenderer {
//    return ComponentRenderer { callback in
//      var state = initialState
//      return Elm.createElement(component: render(state, createDispatch(
//        initialState: initialState,
//        reduce: reduce,
//        render: render,
//        then: callback
//      ))).render()
//    }
//  }
//
//  private static func createDispatch<State, Action>(
//    initialState: State,
//    reduce: @escaping (State, Action) -> State,
//    render: @escaping (State, (Action) -> ()) -> Component,
//    then: @escaping () -> ()
//  ) -> (Action) -> () {
//    var state = initialState
//    return { action in
//      DispatchQueue.global(qos: .userInitiated).sync {
//        let newState = reduce(
//          state,
//          action
//        )
//        newStatefule.state = newState
//        then()
//      }
//    }
//  }
//}



//public enum Component {
//  case baseComponent(element: Element)
//  case statelessComponent(render: () -> Component)
//  case statefulComponent(Stateful<Any, Any>)
//}

//public protocol Elementor {
//  func toTest() -> Test
//}
//
//public protocol Component {}
//
//public protocol BaseComponent: Component {
//  var element: Element { get }
//}
//
//public protocol StatelessComponent: Component {
//  func render() -> Component
//}
//
//public protocol StatefulComponent: Component {
//  associatedtype State
//  associatedtype Action
//
//  func reduce(state: State, action: Action) -> State
//  func render(state: State, dispatch: (Action) -> ()) -> Component
//}
//
//public func label(text: String) -> Component {
//  return BaseComponent(element: .label(text: text))
//}
//
//public enum Axis { case vertical, horizontal }
//
//public func stackLayout(children: [Component], axis: Axis = .vertical) -> Component {
//  return BaseComponent(element:
//    .stackLayout(children: children.map(Elm.createElement), axis: axis)
//  )
//}
//
//public func createStatelessComponent(_ render: @escaping () -> Component) -> Component {
//  return StatelessComponent(render: render)
//}
//
//public func createStatefulComponent<State, Action>(
//  initialState: State,
//  reduce: @escaping (State, Action) -> State,
//  _ render: @escaping (State, (Action) -> ()) -> Component
//) -> Component {
//  return StatefulComponent(state: initialState, render: render, reduce: reduce)
//
//}
//
//public struct Stateful<State, Action> {
//  var state: State
//
//  let render: (State, (Action) -> ()) -> Component
//
//  let reduce: (State, Action) -> State
//}
