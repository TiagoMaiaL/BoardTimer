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
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "timer_cell", for: indexPath)
   
    // Configure the cell...
   
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = SettingsSection(rawValue: section) else { return nil }
    
    switch section {
    case .timers:
      return "Common timers"
    case .custom:
      return "Custom timers"
    case .sounds:
      return "Sounds"
    case .other:
      return ""
    }
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
  }

}
