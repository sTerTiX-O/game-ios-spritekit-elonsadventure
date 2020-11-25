//
//  GameScene.swift
//  Elon's Adventure
//
//  Created by Bénédicte Warot on 15/11/2020.
//  Copyright © 2020 Malo Fonrose. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob: SKNode?
    var cameraNode : SKCameraNode?
    var mountains1 : SKNode?
    var mountains2 : SKNode?
    var mountains3 : SKNode?
    var moon : SKNode?
    var stars : SKNode?
    
    //Boolean
    var joystickAction = false
    
    //Measure
    var knobRadius : CGFloat = 50.0
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed = 4.0
    
    //Player state
    var playerStateMachine : GKStateMachine!

    //didmove
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        mountains1 = childNode(withName: "mountains1")
        mountains2 = childNode(withName: "mountains2")
        mountains3 = childNode(withName: "mountains3")
        moon = childNode(withName: "moon")
        stars = childNode(withName: "stars")
        
        playerStateMachine = GKStateMachine(states: [
        JumpingState(playerNode: player!),
        WalkingState(playerNode: player!),
        IdleState(playerNode: player!),
        LandingState(playerNode: player!),
        StunnedState(playerNode: player!),
        ])
        
        playerStateMachine.enter(IdleState.self)
        
    }
    
}

// MARK: Touches
extension GameScene {
    //Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
            
            let location = touch.location(in: self)
            if !(joystick?.contains(location))! {
                playerStateMachine.enter(JumpingState.self)
            }
        }
    }
    //Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        //Distance
        for touch in touches{
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius )
            }
        }
    }
    //Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetKnobPosition()
    }
    
}
// MARK: Action
extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
}

// MARK: Game Loop
extension GameScene {
    
    /// REMARQUE : Lors de la première version de cette méthode, le joueur disparaissait de l'écran instantanément.
    ///   - C'était lié à un problème de knob qui n'était pas tout à fait positionné en 0,0
    ///   - Du coup, comme lors du premier appel à update(), la valeur de 'previousTimeInterval' n'est pas initialisée, on calculait une valeur énorme de deltaTime et donc une valeur énorme de displacement qui faisait sortir le joueur de l'écran
    ///   - En remettant le knob à (0,0) dans le fichier GameScene.sks, la valeur xPosition à 0 vient annuler l'abberation de la valeur de 'deltaTime' calculée
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        //Camera
        cameraNode?.position.x = player!.position.x
        joystick?.position.y = (cameraNode?.position.y)! - 100
        joystick?.position.x = (cameraNode?.position.x)! - 200
        
        // Player movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let positivePosition = xPosition < 0 ? -xPosition : xPosition

        if floor(positivePosition) != 0 {
            playerStateMachine.enter(WalkingState.self)
        } else {
            playerStateMachine.enter(IdleState.self)
        }
        let xDisplacement = ((deltaTime * playerSpeed) * xPosition)
        let displacement = CGVector(dx: xDisplacement, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        }
        else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
        
        // Background Parallax
        let parallax1 = SKAction.moveTo(x: (player?.position.x)!/(-10), duration: 0.0)
        mountains1?.run(parallax1)
        
        let parallax2 = SKAction.moveTo(x: (player?.position.x)!/(-20), duration: 0.0)
        mountains2?.run(parallax2)
        
        let parallax3 = SKAction.moveTo(x: (player?.position.x)!/(-40), duration: 0.0)
        mountains3?.run(parallax3)

        let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        moon?.run(parallax4)

        let parallax5 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        stars?.run(parallax5)
        
    }
}


// MARK: Collision
extension GameScene: SKPhysicsContactDelegate {
    
    struct Collision {
        
        enum Masks: Int {
            case killing, player, reward, ground
            var bitmask: UInt32 { return 1 << self.rawValue }
            
        }
        
        let masks : (first : UInt32, second : UInt32)

        func matches (_ first : Masks, _ second : Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
            (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {

        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches( .player, .killing) {
            let die = SKAction.move(to: CGPoint(x: -300, y: -75), duration: 0.0)
            player?.run(die)
        }
    }
}
