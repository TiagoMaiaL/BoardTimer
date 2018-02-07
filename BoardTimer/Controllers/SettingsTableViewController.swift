//
//  SettingsTableViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/21/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  /// Enum discribing the possible sections of the settings table view.
  enum Sections: Int {
    case timers = 0
    case custom
    
    /// The number of sections.
    static var count: Int { return custom.hashValue + 1 }
    
    /// The associated titles with each section.
    static let titles = [
      timers: NSLocalizedString("Common timers", comment: "Settings: Default timers section title"),
      custom: NSLocalizedString("Custom timers", comment: "Settings: Custom timers section title"),
      ]
    
    /// Returns the title of the section.
    func getTitle() -> String {
      if let title = Sections.titles[self] {
        return title
      } else {
        return ""
      }
    }
  }

  
  // MARK: Constants
  
  /// Segue id used to present the new timer view controller.
  private let customTimerSegueID = "new_timer"
  
  /// The timers storage
  private let storage = TimerConfigurationStorage()
  
  // MARK: Properties
  
  /// The created custom timers.
  private var customTimers: [TimerConfiguration]!
  
  /// The timer configuration currently chosen in the timer controller.
  var runningConfiguration: TimerConfiguration?
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customTimers = storage.getSavedCustomTimers() ?? []
    
    title = NSLocalizedString("Settings", comment: "Settings: Controller title")
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(didTapDone))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateCustomSection()
  }
  
  // MARK: Actions
  
  @objc func didTapDone() {
    dismiss(animated: true)
  }
  
  // MARK: Imperatives
  
  /// Updates the custom timers section.
  private func updateCustomSection() {
    if let updatedCustomTimers = TimerConfigurationStorage().getSavedCustomTimers() {
      if updatedCustomTimers.count > customTimers.count {
        let customSection = Sections.custom
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
    guard let section = Sections(rawValue: section) else { return nil }
    return section.getTitle()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Sections(rawValue: indexPath.section) else { return }
    
    switch section {
    case .timers:
      let selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[indexPath.row]
      
      dismiss(animated: true) { [unowned self] in
        NotificationCenter.default.post(name: TimerViewController.NotificationName.new.getName(),
                                        object: self,
                                        userInfo: ["timer_config": selectedConfiguration])
      }
    case .custom:
      if indexPath.row <= customTimers.count - 1 {
        dismiss(animated: true) { [unowned self] in
          NotificationCenter.default.post(name: TimerViewController.NotificationName.new.getName(),
                                          object: self,
                                          userInfo: ["timer_config": self.customTimers[indexPath.row]])
        }
      } else {
        performSegue(withIdentifier: customTimerSegueID, sender: self)
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Sections(rawValue: section) else { return 0 }
    
    switch section {
    case .timers:
      return TimerConfiguration.getDefaultConfigurations().count
    case .custom:
      return 1 + customTimers.count
    }
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    guard let section = Sections(rawValue: indexPath.section), section == .custom else { return [] }
    guard indexPath.row < self.customTimers.count else { return [] }
    
    let delete = UITableViewRowAction(style: .destructive,
                                      title: NSLocalizedString("Delete", 
                                                               comment: "Settings: Delete cell action title")) { [unowned self] (action, path) in
      let timerToDelete = self.customTimers[path.row]
      self.storage.remove(timerToDelete)
      self.customTimers = self.storage.getSavedCustomTimers()
      self.tableView.deleteRows(at: [path], with: .right)
    }
    
    return [delete]
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
    
    let cell: UITableViewCell!
    
    switch section {
    case .timers:
      cell = makeTimersCell(path: indexPath, tableView: tableView)
    case .custom:
      cell = makeCustomCell(path: indexPath, tableView: tableView)
    }
    
    return cell
  }
  
  // MARK: Cell factory methods
  
  /// Returns a configured cell for default timers.
  func makeTimersCell(path: IndexPath, tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: path)
    
    let cellConfiguration = TimerConfiguration.getDefaultConfigurations()[path.row]
    
    cell.textLabel?.text = cellConfiguration.name
    
    cell.detailTextLabel?.text = String.localizedStringWithFormat(
      NSLocalizedString("%d min(s)", comment: "Settings: Number of minutes of each timer"),
      cellConfiguration.time.minutes
    )
    
    if self.runningConfiguration != nil {
      cell.accessoryType = cellConfiguration == self.runningConfiguration ? .checkmark : .none
    }
    
    return cell
  }
  
  /// Returns a configured cell for custom timers.
  func makeCustomCell(path: IndexPath, tableView: UITableView) -> UITableViewCell {
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
      cell.textLabel?.text = NSLocalizedString("Create a custom timer", comment: "Settings: Custom timer creation cell title")
    }
    
    return cell
  }
}
