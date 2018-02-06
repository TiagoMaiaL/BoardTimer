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
    
    title = NSLocalizedString("New Timer", comment: "New Timer: controller title")
    
    navigationItem.largeTitleDisplayMode = .never
    setupForm()
  }
  
  // MARK: Setup form
  
  func setupForm() {
    form +++ Section(NSLocalizedString("General", comment: "New Timer: general section title"))
      <<< NameRow(nameTag) {
        $0.title = NSLocalizedString("Name:", comment: "New Timer: timer name form title")
        $0.placeholder = NSLocalizedString("Enter the timer name", comment: "New Timer: timer name form placeholder")
        $0.add(rule: RuleRequired())
      }
      <<< CountDownTimerRow(timeTag) {
        $0.title = NSLocalizedString("Time for each player:", comment: "New Timer: player time form title")
        $0.add(rule: RuleRequired())
        $0.displayValueFor = { value in
          
          let hoursText = String.localizedStringWithFormat(
            NSLocalizedString("%d hr(s)", comment: "New Timer: Amount of hours of the player timer"),
            value!.hours
          )
          
          let minutesText = String.localizedStringWithFormat(
            NSLocalizedString("%d min(s)", comment: "New Timer: Amount of minutes of the player timer"),
            value!.minutes
          )
          
          let secondsText = String.localizedStringWithFormat(
            NSLocalizedString("%d sec(s)", comment: "New Timer: Amount of seconds of the player timer"),
            value!.seconds
          )
          
          if value != nil {
            return "\(hoursText), \(minutesText), \(secondsText)"
          } else {
            return nil
          }
        }
      }
      +++ Section(NSLocalizedString("Delay", comment: "New Timer: Delay section title"))
      <<< SwitchRow(useDelayTag) {
        $0.title = NSLocalizedString("Use delay", comment: "New Timer: Delay usage form title")
        $0.value = false
      }
      <<< SegmentedRow<String>(delayTypeTag) {
        $0.options = Array(TimerConfiguration.Mode.names.values)
        $0.value = "Fischer"
        $0.hidden = "$useDelayTag == false"
        $0.add(rule: RuleRequired())
        $0.onChange { [unowned self] row in
          let labelRow = self.form.rowBy(tag: self.delayLabelTag) as! LabelRow
          
          if let modeName = row.value, let mode = TimerConfiguration.Mode.get(from: modeName) {
            labelRow.title = mode.description
            labelRow.reload()
          }
          
          
        }
      }
      <<< LabelRow(delayLabelTag) {
        $0.title = TimerConfiguration.Mode.fischer.description
        $0.hidden = "$useDelayTag == false"
        $0.cellSetup { (cell, _) in
          cell.height = {100}
          cell.textLabel?.numberOfLines = 0
        }
      }
      <<< StepperRow(delayAmountTag) {
        $0.title = NSLocalizedString("Amount:", comment: "New Timer: Amount form title")
        $0.value = 0
        $0.displayValueFor = { value in
          String.localizedStringWithFormat(NSLocalizedString("%d second(s)",
                                                             comment: "New Timer: Amount of secs display text"),
                                           Int(value ?? 0))
        }
        $0.add(rule: RuleRequired())
        $0.hidden = "$useDelayTag == false"
      }
      +++ Section()
      <<< ButtonRow() {
        $0.title = NSLocalizedString("Create timer", comment: "New Timer: Form button title")
        
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
          
          let timerMode = TimerConfiguration.Mode.get(from: delayType)
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
