//
//  CountDownTimerRow.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 12/18/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import Eureka

final class CountDownTimerRow: Row<CountDownTimerCell>, RowType {
  
  // MARK: Initialization
  
  required init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<CountDownTimerCell>(nibName: "CountDownTimerCell")
  }
  
}
