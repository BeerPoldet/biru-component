import UIKit
import PlaygroundSupport
import BiruComponent
import LayoutKit

var str = "Hello, playground"

//struct HelloWorldComponent: StatefulComponent {
//  enum TextAction {
//    case didTap
//  }
//
//  typealias State = (count: Int, text: String, textColor: UIColor)
//  typealias Action = TextAction
//
//  var state = (count: 0, text: "Click me", textColor: UIColor.blue)
//
//  func render(state: State, send: @escaping (Action) -> ()) -> Component {
//    return Label(text: state.text)
//  }
//
//  func reduce(state: State, action: Action) -> State {
//    switch action {
//    case .didTap:
//      let count = state.count + 1
//      return (
//        count: count,
//        text: "Count: \(count)",
//        textColor: count % 2 == 0 ? .blue : .red
//      )
//    }
//  }
//}

//let rootViewController = Elm.createApp(root: HelloWorldComponent())
//PlaygroundPage.current.liveView = rootViewController

//struct HelloComponent: StatelessComponent {
//  func render() -> Component {
//    return StackLayout(
//      children: [
//        Label(text: "Hello"),
//        StackLayout(children: [
//          Label(text: "Hello Mars"),
//          MarComponent(),
//          HelloWorldComponent()
//        ], axis: .horizontal)
//      ]
//    )
//  }
//}
//
//struct MarComponent: StatelessComponent {
//  func render() -> Component {
//    return Label(text: "I'm Mar")
//  }
//}
//
//let rootComponent = HelloComponent()

//enum CounterAction {
//  case add
//}
//
//let counter = createStatefulComponent(
//  initialState: 1, reduce: { (state: Int, action: CounterAction) -> Int in
//    return state + 1
//}) { (state, send) -> Component in
//  label(text: String(state))
//}
//
//let rootComponent = createStatelessComponent { () -> Component in
//  return stackLayout(children: [
//    counter,
//    label(text: "Hello 1"),
//    label(text: "Hello 2"),
//    stackLayout(
//      children: [
//        label(text: "Hello 3"), label(text: "Hello 4")
//      ],
//      axis: .horizontal
//    )
//  ])
//}

//let element = Elm.createElement(component: rootComponent)

public struct CountState: ElmState {
  var value: Int
}
public enum CountAction: ElmAction {
  case count
}

public class Hello: Component {
  public var rerender: (() -> ())!
  
  public func reduce(state: CountState, action: CountAction) -> CountState {
    var newState = state
    newState.value += 1
    return newState
  }
  
  public func render(state: CountState, dispatch: @escaping (CountAction) -> ()) -> ComponentProtocol? {
    return StackLayout(children: [
      Label(text: "Beer \(state.value)", onTap: {
        dispatch(.count)
      }),
      World(),
      Multi()
    ])
  }
  
  public typealias State = CountState
  public typealias Action = CountAction
  public var state: CountState = CountState(value: 0)
}

class World: StatelessComponent {
  var rerender: (() -> ())!
  
  func render() -> ComponentProtocol? {
    return Label(text: "World")
  }
}

public struct MultiState {
  var count: Int = 1
}

public enum MultiAction {
  case tap
}

public class Multi: Component {
  public var state: MultiState = MultiState()
  
  public typealias State = MultiState
  public typealias Action = MultiAction
  public var rerender: (() -> ())!
  
  public func reduce(state: MultiState, action: MultiAction) -> MultiState {
    var newState = state
    newState.count = state.count * state.count
    return newState
  }
  
  public func render(state: MultiState, dispatch: @escaping (MultiAction) -> ()) -> ComponentProtocol? {
    return Label(text: "Mul: \(state.count)", onTap: {
      dispatch(.tap)
    })
  }
}

let rootViewController = UIViewController()

X.render(component: Hello(), into: rootViewController.view)
rootViewController.view.backgroundColor = .white

PlaygroundPage.current.liveView = rootViewController
//PlaygroundPage.current.needsIndefiniteExecution = true
