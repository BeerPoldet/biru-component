//
//  Renderer.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 10/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

protocol UIKitRenderer {
  func render(rerender: @escaping () -> ()) -> Layout
}

//extension Component {
//  func toVirtual() -> Virtual {
//    switch self {
//    case .base(let element):
//      return .baseComponent(element)
//    case .stateless(let render):
//      return .statelessComponent(render: { render().toVirtual() })
//    case .stateful(let handler):
//      return .statefulComponent(handler)
//    }
//  }
//}

//extension Virtual: UIKitRenderer {
//  public func render(rerender: @escaping () -> ()) -> Layout {
//    switch self {
//    case .baseComponent(let element):
//      switch element {
//      case .label(text: let text):
//        return createLabel(text: text)
//      case let .stackLayout(children, axis):
//        return createStacklayout(children: children, axis: axis, rerender: rerender)
//      }
//    case .statelessComponent(let render):
//      return render().render(rerender: rerender)
//    case .statefulComponent(let stateful):
//      return stateful
//        .render(stateful.state, stateful.createDispatch(then: rerender))
//        .toVirtual()
//        .render(rerender: rerender)
//    }
//  }
//
//  private func createLabel(text: String) -> LabelLayout<UILabel> {
//    let labelLayout = LabelLayout(text: text)
//    return labelLayout
//  }
//
//  private func createStacklayout(children: [Component], axis: Axis, rerender: @escaping () -> ()) -> LayoutKit.StackLayout<UIView> {
//    func mapAxis(_ axis: Axis) -> LayoutKit.Axis {
//      switch axis {
//      case .horizontal: return .horizontal
//      case .vertical: return .vertical
//      }
//    }
//    return LayoutKit.StackLayout(
//      axis: mapAxis(axis),
//      sublayouts: children.map({ $0.toVirtual() }).map({ $0.render(rerender: rerender) })
//    )
//  }
//
////  private static func createSend(
////    stateful: Stateful<Any, Any>,
////    then: @escaping () -> ()
////    ) -> (Any) -> () {
////    var newStatefule = stateful
////    return { action in
////      DispatchQueue.global(qos: .userInitiated).sync {
////        let newState = stateful.reduce(
////          stateful.state,
////          action
////        )
////        newStatefule.state = newState
////        then()
////      }
////    }
////  }
//}


//extension Element {
//  public func toLayout() -> Layout {
//    switch self {
//    case .label(text: let text, onTap: let onTap):
//      return createLabel(text: text, onTap: onTap)
//    case let .stackLayout(children, axis):
//      return createStackLayout(children: children, axis: axis)
//    }
//  }
//
//  private func createLabel(text: String, onTap: (() -> ())?) -> LabelLayout<UILabel> {
//    return LabelLayout(text: text, config: {
//      $0.addTapGestureRecognizer(action: onTap)
//    })
//  }
//
//  private func createStackLayout(children: [ComponentProtocol], axis: Axis) -> LayoutKit.StackLayout<UIView> {
//    func mapAxis(_ axis: Axis) -> LayoutKit.Axis {
//      switch axis {
//      case .horizontal: return .horizontal
//      case .vertical: return .vertical
//      }
//    }
//    return LayoutKit.StackLayout(
//      axis: mapAxis(axis),
//      sublayouts: children.map({ $0.renderView(rerender: nil) })
//    )
//  }
//}

public enum Renderer {
//  public static func renderView(_ element: Element, container: UIView) {
//    element.render(
//      rerender: { renderView(element, container: container) }
//    ).arrangement().makeViews(in: container)
//  }

//  public static func render(component: Component, into container: UIView) {
//    render(virtual: component.toVirtual(), into: container)
//  }
//  
//  public static func render(virtual: Virtual, into container: UIView) {
//    virtual.render(
//      rerender: { render(virtual: virtual, into: container) }
//    ).arrangement().makeViews(in: container)
//  }

//  public static func createElement<Root>(
//    root: Root
//  ) -> UIViewController where Root: Component {
//
//    let viewController = UIViewController()
//    let view: UIView! = viewController.view
//    view.backgroundColor = .white
//
//    render(component: root, state: root.state, view: view)
//    return viewController
//  }
//
//  private static func render<C>(
//    component: C,
//    state: C.State,
//    view: UIView
//  ) where C: Component {
//    component
//      .render(state: state, send: createSend(
//        component: component, view: view, then: render)
//      )
//      .arrangement()
//      .makeViews(in: view)
//  }
//
//  private static func createSend<C>(
//    component: C,
//    view: UIView,
//    then: @escaping (C, C.State, UIView) -> ()
//  ) -> (C.Action) -> () where C: Component {
//    var newComponenet = component
//    return { action in
//      DispatchQueue.global(qos: .userInitiated).sync {
//        let newState = component.reduce(
//          state: newComponenet.state,
//          action: action
//        )
//        newComponenet.state = newState
//        then(newComponenet, newState, view)
//      }
//    }
//  }
}
