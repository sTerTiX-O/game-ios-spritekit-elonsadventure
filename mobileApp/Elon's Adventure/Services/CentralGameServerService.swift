//
//  GameServerConnectionsService.swift
//  Elon's Adventure
//
//  Created by Nicolas (Perso) on 26/11/2020.
//  Copyright © 2020 Malo Fonrose. All rights reserved.
//

import Foundation

class CentralGameServerService {
    
    public static var shared = CentralGameServerService()
    
    public func listAvailableServers() -> Set<GameServer> {
        return Set<GameServer>()
    }
    
}

