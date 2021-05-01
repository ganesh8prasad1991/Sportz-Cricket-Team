//
//  Response.swift
//  Sportz Cricket Team
//
//  Created by Ganesh Prasad on 01/05/21.
//  Copyright © 2021 Sportz Cricket Team. All rights reserved.
//

import Foundation

struct Response {
    let teams: [Team]
    
    
    init(dict: [String: Any]) {
        
        var teamsArray = [Team]()
        if let teams = dict["Teams"] as? [String: AnyObject] {
            
            for (_, team) in teams {
                //Team1 setUp
                if let teamShortName = team["Name_Short"] as? String,
                    let firstTeamPlayers = team["Players"] as? [String: Any]   {
                    
                    var playersInfo = [Player]()
                    for (_, value) in firstTeamPlayers {
                        let playerInfo = value as? [String: Any]
                        let name = playerInfo?["Name_Full"] as? String ?? ""
                        let captainStatus = playerInfo?["Iscaptain"] as? Bool ?? false
                        let position = playerInfo?["Position"] as? String ?? "0"
                        let keeperStatus = playerInfo?["Iskeeper"] as? Bool ?? false
                        
                        let player = Player(
                            name: name,
                            isCaptain: captainStatus,
                            isKeeper: keeperStatus,
                            position: Int(position) ?? 0
                        )
                        playersInfo.append(player)
                    }
                    
                    playersInfo.sort(by: { $0.position < $1.position })
                    
                    let team = Team(
                        shortName: teamShortName,
                        players: playersInfo
                    )
                    teamsArray.append(team)
                }
            }
            
        }
        
        self.teams = teamsArray
        
    }
}

struct Team {
    let shortName: String
    let players: [Player]
}

struct Player {
    let name: String
    let isCaptain: Bool
    let isKeeper: Bool
    let position: Int
    
    
    var nameStatusWithCapAndKeeper: String {
        var textToPrint = name
        if isKeeper && isCaptain {
            textToPrint.append(" (c & wk)")
        }else if isCaptain {
            textToPrint.append(" (c)")
        }else if isKeeper {
            textToPrint.append(" (wk)")
        }
        return textToPrint
    }
    
    var positionStatus: String {
        "Position (\(position))"
    }
}
