//
//  NewTimerViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/19/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import Eureka

class NewTimerViewController: FormViewController {

  // MARK: Constants
  
  let useDelayTag = "useDelayTag"
  let nameTag = "nameTag"
  let timeTag = "timeTag"
  let delayTypeTag = "delayTypeTag"
  let delayLabelTag = "delayLabelTag"
  let delayAmountTag = "delayAmountTag"
  
  // MARK: Properties
  
  let timerStorage = TimerConfigurationStorage()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setupForm()
  }
  
  // MARK: Setup form
  
  func setupForm() {
    form +++ Section("General")
      <<< NameRow(nameTag) {
        $0.title = "Name"
        $0.placeholder = "Enter the timer name"
        $0.add(rule: RuleRequired())
      }
      <<< CountDownTimerRow(timeTag) {
        $0.title = "Time for each player"
        $0.add(rule: RuleRequired())
        $0.displayValueFor = { value in
          
          if value != nil {
            return "\(value!.hours) hrs, \(value!.minutes) min, \(value!.seconds) sec"
          }
          return nil
        }
      }
      +++ Section("Delay")
      <<< SwitchRow(useDelayTag) {
        $0.title = "Use delay"
        $0.value = false
      }
      <<< SegmentedRow<String>(delayTypeTag) {
        $0.options = Array(TimerMode.names.values)
        $0.value = "Fischer"
        $0.hidden = "$useDelayTag == false"
        $0.add(rule: RuleRequired())
        $0.onChange { [unowned self] row in
          let labelRow = self.form.rowBy(tag: self.delayLabelTag) as! LabelRow
          labelRow.title = TimerMode.get(from: row.value!).getDescription()
          labelRow.reload()
        }
      }
      <<< LabelRow(delayLabelTag) {
        $0.title = TimerMode.fischer.getDescription()
        $0.hidden = "$useDelayTag == false"
        $0.cellSetup { (cell, _) in
          cell.height = {100}
          cell.textLabel?.numberOfLines = 0
        }
      }
      <<< StepperRow(delayAmountTag) {
        $0.title = "Amount"
        $0.value = 0
        $0.displayValueFor = { value in
          "\(Int(value ?? 0)) seconds"
        }
        $0.add(rule: RuleRequired())
        $0.hidden = "$useDelayTag == false"
      }
      +++ Section()
      <<< ButtonRow() {
        $0.title = "Create timer"
        
        let tagsToUse = [nameTag, timeTag, useDelayTag, delayTypeTag, delayAmountTag]
        // TODO: Refactor this. Change it to use only strings.
        $0.disabled = Condition.function(tagsToUse) { [unowned self] form -> Bool in
          let nameRow = form.rowBy(tag: self.nameTag) as? NameRow,
              timeRow = form.rowBy(tag: self.timeTag) as? CountDownTimerRow,
              useDelayRow = form.rowBy(tag: self.useDelayTag) as? SwitchRow,
              delayTypeRow = form.rowBy(tag: self.delayTypeTag) as? SegmentedRow<String>,
              delayAmountRow = form.rowBy(tag: self.delayAmountTag) as? StepperRow

          return (nameRow?.value == nil || timeRow?.value == nil) ||
                 (useDelayRow?.value == true &&
                  (delayTypeRow?.value == nil || delayAmountRow?.value == 0))
        }
        
        $0.onCellSelection { [unowned self] (_, buttonRow) in
          let nameRow = self.form.rowBy(tag: self.nameTag) as! NameRow,
              timeRow = self.form.rowBy(tag: self.timeTag) as! CountDownTimerRow,
              delayTypeRow = self.form.rowBy(tag: self.delayTypeTag) as! SegmentedRow<String>,
              delayAmountRow = self.form.rowBy(tag: self.delayAmountTag) as! StepperRow
          
          guard let time = timeRow.value else { return }
          guard let delay = delayAmountRow.value else { return }
          guard let delayType = delayTypeRow.value else { return }
          guard let name = nameRow.value else { return }
          
          let timerMode = TimerMode.get(from: delayType)
          let timer = TimerConfiguration(time: time,
                                         delay: delay,
                                         mode: timerMode,
                                         name: name)
          self.timerStorage.store(timer)
          self.navigationController?.popViewController(animated: true)
        } 
      }
  }
}
