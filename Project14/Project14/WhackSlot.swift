//
//  WhackSlot.swift
//  Project14
//
//  Created by LeeKyungjin on 30/04/2019.
//  Copyright © 2019 daisy. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var sprite: SKSpriteNode! //whackhole
    var mudEffect: SKEmitterNode!
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0 , y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
     
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        if mudEffect == nil {
            mudEffect = SKEmitterNode(fileNamed: "mud")
            mudEffect.position = CGPoint(x: sprite.position.x, y: sprite.position.y - 40)
            addChild(mudEffect)
        }
        
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        if mudEffect != nil {
            mudEffect.removeFromParent()
            mudEffect = nil
        }
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in
            if self?.mudEffect != nil {
                self?.mudEffect.removeFromParent()
                self?.mudEffect = nil
            }
            self?.isVisible = false
        }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
