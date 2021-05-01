//
//  Response.swift
//  Sportz Cricket Team
//
//  Created by Ramniwas Patidar(Xebia) on 01/05/21.
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
                        let player = Player(name: name, isCaptain: captainStatus, position: Int(position) ?? 0)
                        playersInfo.append(player)
                    }
                    
                    playersInfo.sort(by: { $0.position < $1.position })
                    
                    teamsArray.append(Team(shortName: teamShortName, players: playersInfo))
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
    let position: Int
}
