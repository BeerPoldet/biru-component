//
//  Element.swift
//  BiruComponent
//
//  Created by Poldet Assanangkornchai on 10/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import Foundation

public indirect enum Element {
  case label(text: String)
  case stackLayout(children: [Element], axis: StackLayout.Axis)
}

//struct ViewController: Element {
//
//}
//
//struct Label: Element {
//  let text: String?
//}
