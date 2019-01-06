//
//  TypeEraser.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 6/1/19.
//  Copyright © 2019 Assanee. All rights reserved.
//

import Foundation

public struct ConstantIterator: IteratorProtocol {
  mutating public func next() -> Int? {
    return 1
  }
}

// MARK: - 1

public class IteratorBox<A>: IteratorProtocol {
  public func next() -> A? {
    fatalError("This method is abstract.")
  }
}

public class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
  var iterator: I
  init(_ iterator: I) {
    self.iterator = iterator
  }
  
  override public func next() -> I.Element? {
    return iterator.next()
  }
}

// MARK: - 2

public class AnyIterator<A>: IteratorProtocol {
  var nextImpl: () -> A?
  
  init<I: IteratorProtocol>(_ iterator: I) where I.Element == A {
    var iteratorCopy = iterator
    self.nextImpl = { iteratorCopy.next() }
  }
  
  public func next() -> A? {
    return nextImpl()
  }
}

// let iterator: IteratorProtocol = ConstantIterator()

public let iter: IteratorBox = IteratorBoxHelper(ConstantIterator())
public let anyIter: AnyIterator = AnyIterator(ConstantIterator())

public protocol StateNaja {
  init()
}

public protocol Com {
  var internalState: StateNaja { get set }
  init()
}

public class ComA<A: StateNaja>: Com {
  
  public required init() {
    self.state = A()
  }
  
  public var state: A
  
  public var internalState: StateNaja {
    get {
      return state
    }
    set {
      if let newValue = newValue as? A {
        state = newValue
      }
    }
  }
}

public struct StateA: StateNaja {
  var message: String = ""
  public init() {}
}

public class HiCom: ComA<StateA> {
  
}

public indirect enum K {
  case e(E)
  case com(Com.Type)
}

public struct E {
  var k: K
  public init(k: K) {
    self.k = k
  }
}

public func run() {
  
  var e1 = E(k: K.e(E(k: K.com(HiCom.self))))
  
  a(k: e1.k)
}

func a(k: K) {
  switch k {
  case .e(let e):
    a(k: e.k)
  case .com(let comType):
    var x = comType.init()
    print(x.internalState)
    var s = StateA()
    s.message = "YoYo"
    x.internalState = s
    print(x.internalState)
  }
}
