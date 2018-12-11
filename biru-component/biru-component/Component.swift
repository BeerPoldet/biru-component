//
//  Created by Poldet Assanangkornchai on 8/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import LayoutKit

public protocol Component {}

public protocol StatelessComponent: Component {
  func render() -> Component
}

public protocol StatefulComponent: Component {
  associatedtype State
  associatedtype Action

  var state: State { get set }

  func render(state: State, send: @escaping (Action) -> ()) -> Component

  func reduce(state: State, action: Action) -> State
}

public protocol BaseComponent: Component {
  var element: Element { get }
}

public struct Label: BaseComponent {
  let text: String

  public init(text: String) {
    self.text = text
  }

  public var element: Element {
    return .label(text: text)
  }
}

public struct StackLayout: BaseComponent {
  public enum Axis { case vertical, horizontal }

  let children: [Component]
  let axis: Axis

  public init(children: [Component], axis: Axis = .vertical) {
    self.children = children
    self.axis = axis
  }

  public var element: Element {
    return .stackLayout(children: children.map(Elm.createElement), axis: axis)
  }
}
