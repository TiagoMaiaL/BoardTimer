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
  
  let customTimerSegueID = "new_timer"
  
  // MARK: Properties
  
  var customTimers: [TimerConfiguration] {
    get {
      return TimerConfigurationStorage().getSavedCustomTimers() ?? []
    }
  }
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(didTapDone))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: Actions
  
  @objc func didTapDone() {
    dismiss(animated: true)
  }
}

// MARK: - Table view data source

extension SettingsTableViewController {
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = SettingsSection(rawValue: section) else { return nil }
    return section.getTitle()
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "header_cell") else { return nil }
    
    let titleTag = 1
    let titleLabel = cell.viewWithTag(titleTag) as? UILabel
    
    titleLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100
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
      break
    case .custom:
      // TODO: Check what cell is being tapped.
      performSegue(withIdentifier: customTimerSegueID, sender: self)
      break
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
    
    let timer = TimerConfiguration.getDefaultConfigurations()[path.row]
    
    cell.textLabel?.text = timer.name
    cell.detailTextLabel?.text = "\(Int(timer.time)) min"
    
    return cell
  }
  
  func getCustomCell(for path: IndexPath, and tableView: UITableView) -> UITableViewCell {
    var cell: UITableViewCell!
    
    if path.row <= customTimers.count - 1 {
      let timer = customTimers[path.row]
      cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: path)
      cell.textLabel?.text = timer.name
      cell.detailTextLabel?.text = "\(Int(timer.time)) min"
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "common_cell", for: path)
      cell.textLabel?.text = "Create a custom timer"
    }
    
    return cell
  }
}

// MARK: Data source enums

// TODO: Refactor this enum.

enum SettingsSection: Int {
  case timers = 0, custom/*, sounds, other*/
  
  static var count: Int { return custom.hashValue + 1 }
  
  static let titles = [
    timers: "Common timers",
    custom: "Custom timers",
    //      sounds: "Sounds",
    //      other: ""
  ]
  
  func getTitle() -> String {
    if let title = SettingsSection.titles[self] {
      return title
    } else {
      return ""
    }
  }

}

