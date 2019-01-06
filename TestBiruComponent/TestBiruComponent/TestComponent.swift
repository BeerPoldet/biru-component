//
//  TestComponent.swift
//  TestBiruComponent
//
//  Created by Poldet Assanangkornchai on 15/12/18.
//  Copyright © 2018 Poldet Assanangkornchai. All rights reserved.
//

import Foundation
import BiruComponent

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
    newState.count = (state.count + 1) * state.count
    return newState
  }
  
  public func render(state: MultiState, dispatch: @escaping (MultiAction) -> ()) -> ComponentProtocol? {
    return Label(text: "Mul: \(state.count)", onTap: {
      dispatch(.tap)
    })
  }
}
