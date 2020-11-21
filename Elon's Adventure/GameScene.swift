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
    
    //Boolean
    var joystickAction = false
    
    //Measure
    var knobRadius : CGFloat = 50.0
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed = 4.0

    //didmove
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
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

        // Player movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let xDisplacement = ((deltaTime * playerSpeed) * xPosition)
        let displacement = CGVector(dx: xDisplacement, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        player?.run(move)
    }
}
