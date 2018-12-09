//
//  Created by Poldet Assanangkornchai on 8/12/18.
//  Copyright © 2018 Assanee. All rights reserved.
//

import UIKit
import LayoutKit

public enum Elm {
  public static func createApp<Root>(root: Root) -> UIViewController where Root: Component {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .white
    root.render().arrangement().makeViews(in: viewController.view)

    return viewController
  }
}
