//: [Previous](@previous)

import PlaygroundSupport
import BiruComponent
import UIKit

class X: ComponentB<Int> {
  required init() {
    super.init()
    state = 0
  }
  
  override func render() -> ElementA? {
    return BiruA.label(
      text: "Hello: \(String(state))",
      onTap: handleTap
    )
  }
  
  func handleTap() {
    setState(state + 1)
  }
}

class B: ComponentB<Int> {
  required init() {
    super.init()
    state = 0
  }
  
  override func render() -> ElementA? {
    return BiruA.createElement(component: X.self)
  }
  
  func handleTap() {
    setState(state + 1)
  }
}

let element = BiruA.createElement(component: B.self)

class ViewController: UIViewController {
  var renderer: RendererA!
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    renderer = BiruA.render(element: element, into: view)
  }
}

PlaygroundPage.current.liveView = ViewController()
PlaygroundPage.current.needsIndefiniteExecution = true


//: [Next](@next)
