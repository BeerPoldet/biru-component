import UIKit
import PlaygroundSupport
import BiruComponent
import LayoutKit

var str = "Hello, playground"

final class HelloWorldComponent: Component {
  enum TextAction {
    case didTap
  }

  typealias State = (count: Int, text: String, textColor: UIColor)
  typealias Action = TextAction

  var state = (count: 0, text: "Click me", textColor: UIColor.blue)

  func render(state: State, send: @escaping (Action) -> ()) -> Layout {
    return InsetLayout(
      insets: EdgeInsets.init(top: 100, left: 50, bottom: 50, right: 100),
      sublayout: LabelLayout(text: state.text, config: {
        $0.addTapGestureRecognizer(action: {
          send(.didTap)
        })
        $0.textColor = .white
        $0.backgroundColor = state.textColor
      })
    )
  }

  func reduce(state: State, action: Action) -> State {
    print(state)
    switch action {
    case .didTap:
      let count = state.count + 1
      return (
        count: count,
        text: "Count: \(count)",
        textColor: count % 2 == 0 ? .blue : .red
      )
    }

    return state
  }
}

let rootViewController = Elm.createApp(root: HelloWorldComponent())
PlaygroundPage.current.liveView = rootViewController
PlaygroundPage.current.needsIndefiniteExecution = true
