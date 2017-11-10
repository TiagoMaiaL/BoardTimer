//
//  ViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet weak var playerALabel: UILabel!
  
  private var timer = TimerManager(first: Player(),
                                   second: Player(),
                                   configuration: (amount: 60 * 2, increase: 12))
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Actions
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    
  }
  

}

