//
//  CustomDataSource.swift
//  Sportz Cricket Team
//
//  Created by Ganesh Prasad on 01/05/21.
//  Copyright © 2021 Sportz Cricket Team. All rights reserved.
//

import UIKit

typealias DataSource = UITableViewDataSource & UITableViewDelegate

class CustomDataSource: NSObject, DataSource {
    
    let tableView: UITableView!
    var teams: [Team]
    var selectedIndex: Int {
        didSet {
            tableView.reloadData()
        }
    }
    let cellId = "cellId"
    
    init(tableView: UITableView, teams: [Team], selectedIndex: Int) {
        self.tableView = tableView
        self.teams = teams
        self.selectedIndex = selectedIndex
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellId
        )
        super.init()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        return teams[selectedIndex].players.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let player = teams[selectedIndex].players[indexPath.item]
        cell.textLabel?.text = player.nameStatusWithCapAndKeeper
        cell.detailTextLabel?.text = player.positionStatus
        return cell
    }
}
