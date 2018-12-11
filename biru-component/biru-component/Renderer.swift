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
  func render() -> Layout
}

extension Element: UIKitRenderer {
  public func render() -> Layout {
    switch self {
    case .label(text: let text):
      return createLabel(text: text)
    case let .stackLayout(children, axis):
      return createStacklayout(children: children, axis: axis)
    }
  }

  private func createLabel(text: String) -> LabelLayout<UILabel> {
    let labelLayout = LabelLayout(text: text)
    return labelLayout
  }

  private func createStacklayout(children: [Element], axis: StackLayout.Axis) -> LayoutKit.StackLayout<UIView> {
    func mapAxis(_ axis: StackLayout.Axis) -> LayoutKit.Axis {
      switch axis {
      case .horizontal: return .horizontal
      case .vertical: return .vertical
      }
    }
    return LayoutKit.StackLayout(
      axis: mapAxis(axis),
      sublayouts: children.map({ $0.render() })
    )
  }

//  private static func createSend(
//      component: StatefulComponent<Any, Any>,
//      then: @escaping () -> ()
//    ) -> (Any) -> () {
//      var newComponenet = component
//      return { action in
//        DispatchQueue.global(qos: .userInitiated).sync {
//          let newState = component.reduce(
//            state: newComponenet.state,
//            action: action
//          )
//          newComponenet.state = newState
//          then()
//        }
//      }
//    }
}

public enum Renderer {
  public static func renderView(_ element: Element) -> UIView {
    return element.render().arrangement().makeViews()
  }

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
