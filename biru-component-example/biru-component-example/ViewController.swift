//
//  ViewController.swift
//  biru-component-example
//
//  Created by Poldet Assanangkornchai on 6/1/19.
//  Copyright © 2019 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import BiruComponent

class ViewController: UIViewController {
  
  let renderer = RendererC()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    renderer.render(element: createElement(Hello.self), root: view)
  }
}

struct HelloState {
  var message: String = "SHOSDfLSIDJF"
  var count: Int = 1
}

class Name: ComponentC<NoStateC> {
  
  override func render() -> ElementC? {
    return label(text: "My name is Beer")
  }
}

class World: ComponentC<String> {
  override var initialState: String! { return "Hello" }
  var timer: Timer?
  
  override func render() -> ElementC? {
    var children = [
      label(text: "\(state), World"),
      createElement(Name.self)
    ]
    if state == "Hi" {
      children.insert(createElement(Name.self), at: 0)
    }
    return stack(children: children)
  }
  
  override func componentDidMount() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (_) in
      print("^&&&&&&&&&&&&&&&&&&&&&&&& COMPONENTC", Unmanaged.passUnretained(self).toOpaque())
      self.setState("Hi")
    }
  }
  
  override func componentWillUnmount() {
    timer?.invalidate()
  }
}

class Hello: ComponentC<HelloState> {
  
  override var initialState: HelloState! { return HelloState() }
  
  override func render() -> ElementC? {
    if state.count < 2 {
      return stack(
        children: state.count < 5
          ? (0...state.count).map {
            label(text: "\(state.message) \($0)", key: String($0))
            }
          : [label(text: "eiei \(state.message) \(state.count)")]
      )
    } else if state.count < 3 {
      return createElement(World.self)
    } else if state.count < 5 {
      return nil
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
