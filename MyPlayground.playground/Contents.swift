import UIKit
import PlaygroundSupport
import BiruComponent
import LayoutKit

var str = "Hello, playground"

struct HelloWorldComponent: StatefulComponent {
  enum TextAction {
    case didTap
  }

  typealias State = (count: Int, text: String, textColor: UIColor)
  typealias Action = TextAction

  var state = (count: 0, text: "Click me", textColor: UIColor.blue)

  func render(state: State, send: @escaping (Action) -> ()) -> Component {
    return Label(text: state.text)
  }

  func reduce(state: State, action: Action) -> State {
    switch action {
    case .didTap:
      let count = state.count + 1
      return (
        count: count,
        text: "Count: \(count)",
        textColor: count % 2 == 0 ? .blue : .red
      )
    }
  }
}

//let rootViewController = Elm.createApp(root: HelloWorldComponent())
//PlaygroundPage.current.liveView = rootViewController

struct HelloComponent: StatelessComponent {
  func render() -> Component {
    return StackLayout(
      children: [
        Label(text: "Hello"),
        StackLayout(children: [
          Label(text: "Hello Mars"),
          MarComponent(),
          HelloWorldComponent()
        ], axis: .horizontal)
      ]
    )
  }
}

struct MarComponent: StatelessComponent {
  func render() -> Component {
    return Label(text: "I'm Mar")
  }
}

let rootComponent = HelloComponent()

let element = Elm.createElement(component: rootComponent)

let rootViewController = UIViewController()
rootViewController.view = Renderer.renderView(element)
rootViewController.view.backgroundColor = .white

PlaygroundPage.current.liveView = rootViewController
PlaygroundPage.current.needsIndefiniteExecution = true
