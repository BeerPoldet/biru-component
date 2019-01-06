//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import BiruComponent

struct HelloState: StateC {
  var message: String = "Hello"
  var count: Int = 1
}

class Name: ComponentC<NoStateC> {
  
  override func render() -> ElementC? {
    return label(text: "My name is Beer")
  }
}

struct WorldState: StateC {
  var x: String = "Hello"
}

class World: ComponentC<WorldState> {
  
  override func render() -> ElementC? {
    var children = [
      label(text: "\(state.x), World"),
      createElement(Name.self)
    ]
    if state.x == "Hi" {
      children.insert(createElement(Name.self), at: 0)
    }
    return stack(children: children)
  }
  
  override func componentDidMount() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (_) in
      self.setState(WorldState(x: "Hi"))
    }
  }
}

class Hello: ComponentC<HelloState> {
  
  override func render() -> ElementC? {
    if state.count < 2 {
      return stack(
        children: state.count < 5
          ? (0...state.count).map {
              label(text: "\(state.message) \($0)", key: String($0))
            }
          : [label(text: "eiei \(state.message) \(state.count)")]
      )
    } else {
      return createElement(World.self)
    }
  }
  
  override func componentDidMount() {
    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [unowned self] (_) in
      self.setState(HelloState(message: "Beer", count: self.state.count + 1))
    }
  }
}

let view = UIView()
view.backgroundColor = .white
view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 500))

let renderer = RendererC()
renderer.render(element: createElement(Hello.self), root: view)

PlaygroundPage.current.liveView = view
//PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
