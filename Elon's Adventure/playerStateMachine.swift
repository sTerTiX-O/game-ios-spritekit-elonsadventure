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
        
        if hasFinishedJumping && stateClass is LandingState.Type { return true }
        return false
    }
    
    let textures : Array<SKTexture> = (0..<2).map({ return "jump/\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures, timePerFrame: 0.1)} ()
    
    override func didEnter(from previousState: GKState?) {
        
        playerNode.removeAction(forKey: characterAnimationKey)
        playerNode.run(action, withKey: characterAnimationKey)
        hasFinishedJumping = false
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 75), duration: 0.1))
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {(timer) in self.hasFinishedJumping = true
            
        }
    }
}
class LandingState : PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {

        switch stateClass {
        case is LandingState.Type, is JumpingState.Type: return false
        default: return true
        }
    }

    override func didEnter(from previousState: GKState?) {

        stateMachine?.enter(IdleState.self)
    }
}

class IdleState : PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {

        switch stateClass {
        case is LandingState.Type, is IdleState.Type: return false
        default: return true
        }
    }

    let textures = SKTexture(imageNamed: "player/0")
    lazy var action = { SKAction.animate(with: [textures], timePerFrame: 0.1)} ()
        override func didEnter(from previousState: GKState?) {

            playerNode.removeAction(forKey: characterAnimationKey)
            playerNode.run(action, withKey: characterAnimationKey)
        }
    }
class WalkingState : PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {

        switch stateClass {
        case is LandingState.Type, is WalkingState.Type : return false
        default: return true
        }
    }

    let textures : Array<SKTexture> = (0..<6).map({ return "player/\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(.animate(with: textures, timePerFrame: 0.1))} ()

    override func didEnter(from previousState: GKState?) {
        playerNode.removeAction(forKey: characterAnimationKey)
        playerNode.run(action, withKey: characterAnimationKey)
    }
}

class StunnedState : PlayerState {
    
}
