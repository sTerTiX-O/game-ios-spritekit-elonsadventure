//
//  playerStateMachine.swift
//  Elon's Adventure
//
//  Created by Nicolas (Perso) on 22/11/2020.
//  Copyright © 2020 Malo Fonrose. All rights reserved.
//

import Foundation
import GameplayKit

fileprivate let characterAnimationKey = "Sprite Animation"

class PlayerState: GKState {
    unowned var playerNode: SKNode
    
    init(playerNode : SKNode){
        self.playerNode = playerNode
        
        super.init()
    }
}

class JumpingState : PlayerState {
    var hasFinishedJumping : Bool = false
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        hasFinishedJumping = false
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 75), duration: 0.1))
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {(timer) in self.hasFinishedJumping = true
            
        }
    }
}
