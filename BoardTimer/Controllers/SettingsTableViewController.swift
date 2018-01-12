//
//  SettingsTableViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/21/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  // MARK: Constants
  
  private let customTimerSegueID = "new_timer"
  private let storage = TimerConfigurationStorage()
  
  // MARK: Properties
  
  private var customTimers: [TimerConfiguration]!
  var runningConfiguration: TimerConfiguration?
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customTimers = storage.getSavedCustomTimers() ?? []
    
    title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(didTapDone))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    refreshCustomSection()
  }
  
  // MARK: Actions
  
  @objc func didTapDone() {
    dismiss(animated: true)
  }
  
  // MARK: Imperatives
  
  private func refreshCustomSection() {
    if let updatedCustomTimers = TimerConfigurationStorage().getSavedCustomTimers() {
      if updatedCustomTimers.count > customTimers.count {
        let customSection = SettingsSection.custom
        let path = IndexPath(row: updatedCustomTimers.count - 1, section: customSection.rawValue)
        
        customTimers = updatedCustomTimers
        tableView.insertRows(at: [path], with: .automatic)
      }
    }
  }
}

// MARK: - Table view data source

extension SettingsTableViewController {
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = SettingsSection(rawValue: section) else { return nil }
    return section.getTitle()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = SettingsSection(rawValue: indexPath.section) else { return }
    
    switch section {
    case .timers:
      let selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[indexPath.row]
      
      dismiss(animated: true) { [unowned self] in
        NotificationCenter.default.post(name: NotificationName.newTimer,
                                        object: self,
                                        userInfo: ["timer_config": selectedConfiguration])
      }
    case .custom:
      if indexPath.row <= customTimers.count - 1 {
        dismiss(animated: true) { [unowned self] in
          NotificationCenter.default.post(name: NotificationName.newTimer,
                                          object: self,
                                          userInfo: ["timer_config": self.customTimers[indexPath.row]])
        }
      } else {
        performSegue(withIdentifier: customTimerSegueID, sender: self)
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return SettingsSection.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = SettingsSection(rawValue: section) else { return 0 }
    
    switch section {
    case .timers:
      return TimerConfiguration.getDefaultConfigurations().count
    case .custom:
      return 1 + customTimers.count
    }
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    guard let section = SettingsSection(rawValue: indexPath.section), section == .custom else { return [] }
    guard indexPath.row < self.customTimers.count else { return [] }
    
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (action, path) in
      let timerToDelete = self.customTimers[path.row]
      self.storage.remove(timerToDelete)
      self.customTimers = self.storage.getSavedCustomTimers()
      self.tableView.deleteRows(at: [path], with: .right)
    }
    
    return [delete]
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
    
    let cell: UITableViewCell!
    
    switch section {
    case .timers:
      cell = getTimersCell(for: indexPath, and: tableView)
    case .custom:
      cell = getCustomCell(for: indexPath, and: tableView)
    }
    
    return cell
  }
  
  // MARK: Cell factory methods
  
  func getTimersCell(for path: IndexPath, and tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: path)
    
    let cellConfiguration = TimerConfiguration.getDefaultConfigurations()[path.row]
    
    cell.textLabel?.text = cellConfiguration.name
    cell.detailTextLabel?.text = "\(Int(cellConfiguration.time.minutes)) min"
    
    if self.runningConfiguration != nil {
      cell.accessoryType = cellConfiguration == self.runningConfiguration ? .checkmark : .none
    }
    
    return cell
  }
  
  func getCustomCell(for path: IndexPath, and tableView: UITableView) -> UITableViewCell {
    var cell: UITableViewCell!
    
    if path.row <= customTimers.count - 1 {
      let timer = customTimers[path.row]
      cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: path)
      cell.textLabel?.text = timer.name
      cell.detailTextLabel?.text = timer.description
      
      if self.runningConfiguration != nil {
        cell.accessoryType = timer == self.runningConfiguration ? .checkmark : .none
      }
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "common_cell", for: path)
      cell.textLabel?.text = "Create a custom timer"
    }
    
    return cell
  }
}

// MARK: Data source enums

enum SettingsSection: Int {
  case timers = 0, custom
  
  static var count: Int { return custom.hashValue + 1 }
  
  static let titles = [
    timers: "Common timers",
    custom: "Custom timers",
  ]
  
  func getTitle() -> String {
    if let title = SettingsSection.titles[self] {
      return title
    } else {
      return ""
    }
  }

}

