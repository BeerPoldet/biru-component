//
//  ViewController.swift
//  TestBiruComponent
//
//  Created by Poldet Assanangkornchai on 15/12/18.
//  Copyright © 2018 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import BiruComponent

class ViewController: UIViewController {
  
  override func loadView() {
    super.loadView()
    
    view.backgroundColor = .white
    view.bounds = CGRect(origin: CGPoint(x: 0, y: -100), size: view.bounds.size)
    X.render(component: Hello(), into: view)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .compose,
      target: self,
      action: #selector(self.pushMore(_:))
    )
  }
  
  @objc func pushMore(_ sender: Any) {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}

