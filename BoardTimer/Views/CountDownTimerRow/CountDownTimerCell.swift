//
//  CountDownTimerCell.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 12/18/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import Eureka

final class CountDownTimerCell: Cell<PlayerTime>, CellType, UIPickerViewDelegate, UIPickerViewDataSource {

  // MARK: Types
  
  enum PickerComponent: Int {
    case Hour = 0, Minute, Second
    
    static var count: Int { return PickerComponent.Second.rawValue + 1 }
    
    static let names = [
      Hour: NSLocalizedString("Hrs", "New Timer: Selection component label."),
      Minute: NSLocalizedString("Min", comment: "New Timer: Selection component label."),
      Second: NSLocalizedString("Sec", comment: "New Timer: Selection component label."),
    ]
    
    func getName() -> String {
      return PickerComponent.names[self]!
    }
  }
  
  // MARK: Properties
  
  var countDownPicker = UIPickerView()
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  // MARK: Initialization
  
  required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: Life cycle
  
  override func setup() {
    super.setup()
    
    accessoryType = .none
    editingAccessoryType = .none
    
    countDownPicker.delegate = self
    countDownPicker.dataSource = self
  }
  
  override func update() {
    titleLabel.text = row.title
    displayValue()
  }
  
  private func displayValue() {
    guard let value = row.value else {
      valueLabel.text = ""
      return
    }
    guard let displayer = row.displayValueFor else {
      valueLabel.text = ""
      return
    }
    
    valueLabel.text = displayer(value)
  }
  
  override open var inputView: UIView? {
    if let value = row.value {
      countDownPicker.selectRow(value.hours,
                                inComponent: PickerComponent.Hour.rawValue,
                                animated: false)
      countDownPicker.selectRow(value.minutes,
                                inComponent: PickerComponent.Minute.rawValue,
                                animated: false)
      countDownPicker.selectRow(value.seconds,
                                inComponent: PickerComponent.Second.rawValue,
                                animated: false)
    }
    return countDownPicker
  }
  
  open override func cellCanBecomeFirstResponder() -> Bool {
    return canBecomeFirstResponder
  }
  
  override open var canBecomeFirstResponder: Bool {
    return !row.isDisabled
  }
  
  // MARK: Picker dataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return PickerComponent.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let component = PickerComponent(rawValue: component) else { return 0 }
    
    switch component {
    case .Hour:
      return 20
    case .Minute, .Second:
      return 60
    }
  }
  
  // MARK: Picker delegate
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let component = PickerComponent(rawValue: component) else { return nil }
    return "\(row) \(component.getName())"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedHour = pickerView.selectedRow(inComponent: PickerComponent.Hour.rawValue)
    let selectedMinute = pickerView.selectedRow(inComponent: PickerComponent.Minute.rawValue)
    let selectedSecond = pickerView.selectedRow(inComponent: PickerComponent.Second.rawValue)
    
    self.row.value = PlayerTime(hours: selectedHour,
                                minutes: selectedMinute,
                                seconds: selectedSecond)
    displayValue()
  }
}
