//
//  SettingsTableViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/21/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(didTapDone))
  }
  
  // MARK: Actions
  
  @objc func didTapDone() {
    dismiss(animated: true)
  }
}

// MARK: - Table view data source

extension SettingsTableViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return SettingsSection.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = SettingsSection(rawValue: section) else { return 0 }
    return section.getRowsNumber()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
    return section.getCell(for: indexPath.row, and: tableView)
  }
  
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
  
  // MARK: Data source enums
  
  enum SettingsSection: Int {
    case timers = 0, custom, sounds, other
    
    static var count: Int { return other.hashValue + 1 }
    
    static let titles = [
      timers: "Common timers",
      custom: "Custom timers",
      sounds: "Sounds",
      other: ""
    ]
    static let rowsCount = [ // TODO: Return the correct number of rows.
      timers: TimerConfiguration.getDefaultConfigurations().count,
      custom: 1,
      sounds: 1,
      other: 1
    ]
    
    func getTitle() -> String {
      if let title = SettingsSection.titles[self] {
        return title
      } else {
        return ""
      }
    }
    
    func getRowsNumber() -> Int {
      if let count = SettingsSection.rowsCount[self] {
        return count
      } else {
        return 0
      }
    }
    
    // MARK: Cell factory methods
    
    private func getPath(from row: Int) -> IndexPath {
      return IndexPath(row: row, section: hashValue)
    }
    
    func getCell(for row: Int, and tableView: UITableView) -> UITableViewCell {
      let cell: UITableViewCell!
      
      switch self {
      case .timers:
        cell = getTimersCell(for: row, and: tableView)
      case .custom:
        cell = getCustomCell(for: row, and: tableView)
      case .sounds:
        cell = UITableViewCell()
      case .other:
        cell = getOtherCell(for: row, and: tableView)
      }
      
      return cell
    }
    
    func getTimersCell(for row: Int, and tableView: UITableView) -> UITableViewCell {
      let path = getPath(from: row)
      let cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: path)
      
      let timer = TimerConfiguration.getDefaultConfigurations()[row]
      
      cell.textLabel?.text = timer.name
      cell.detailTextLabel?.text = "\(timer.time) min"
      
      return cell
    }
    
    func getCustomCell(for row: Int, and tableView: UITableView) -> UITableViewCell {
      let path = getPath(from: row)
      let cell = tableView.dequeueReusableCell(withIdentifier: "common_cell", for: path)
      
      cell.textLabel?.text = "Create a custom timer"
      
      return cell
    }
    
    func getOtherCell(for row: Int, and tableView: UITableView) -> UITableViewCell {
      return UITableViewCell()
    }
    
  }
  
}
