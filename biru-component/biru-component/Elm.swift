//
//  Created by Poldet Assanangkornchai on 8/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

public enum Elm {
  public static func createApp<Root>(root: Root) -> UIViewController where Root: Component {

    let viewController = UIViewController()
    let view: UIView! = viewController.view
    view.backgroundColor = .white

    render(component: root, state: root.state, view: view)
    return viewController
  }

  private static func render<C>(
    component: C,
    state: C.State,
    view: UIView
  ) where C: Component {
    component
      .render(state: state, send: createSend(component: component, view: view, then: render))
      .arrangement()
      .makeViews(in: view)
  }

  private static func createSend<C>(
    component: C,
    view: UIView,
    then: @escaping (C, C.State, UIView) -> ()
  ) -> (C.Action) -> () where C: Component {
    var newComponenet = component
    return { action in
      DispatchQueue.global(qos: .userInitiated).sync {
        let newState = component.reduce(state: newComponenet.state, action: action)
        newComponenet.state = newState
        then(newComponenet, newState, view)
      }
    }
  }
}
