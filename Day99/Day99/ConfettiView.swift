//
//  ConfettiView.swift
//  Day99
//
//  Created by LeeKyungjin on 20/07/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit


private let kAnimationLayerKey = "com.nshipster.animationLayer"

final class ConfettiView: UIView {
    func emit(with contents: [Content], for duration: TimeInterval = 3.0) {
        let layer = Layer()
        layer.configure(with: contents)
        layer.frame = self.bounds
        layer.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(layer)
        
        guard duration.isFinite else { return }
        
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        layer.beginTime = CACurrentMediaTime()
        layer.birthRate = 1.0
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(layer, forKey: kAnimationLayerKey)
            transition.isRemovedOnCompletion = false
            
            layer.add(transition, forKey: nil)
            
            layer.opacity = 0
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
}

// MARK: - CAAnimationDelegate

extension ConfettiView: CAAnimationDelegate {
    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: kAnimationLayerKey) as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
}

