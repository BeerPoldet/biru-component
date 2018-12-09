import UIKit
import PlaygroundSupport
import BiruComponent
import LayoutKit

var str = "Hello, playground"

final class HelloWorldComponent: Component {
  func render() -> Layout {
    return InsetLayout(
      insets: EdgeInsets.init(top: 100, left: 50, bottom: 50, right: 100),
      sublayout: LabelLayout(text: "Hello World")
    )
  }
}

let rootViewController = Elm.createApp(root: HelloWorldComponent())
PlaygroundPage.current.liveView = rootViewController
PlaygroundPage.current.needsIndefiniteExecution = true
