//
//  Created by Poldet Assanangkornchai on 8/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import LayoutKit

public protocol Component {

  associatedtype State
  associatedtype Action

  var state: State { get set }

  func render(state: State, send: @escaping (Action) -> ()) -> Layout

  func reduce(state: State, action: Action) -> State
}
