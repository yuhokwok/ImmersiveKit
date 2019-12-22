//
//  GazeTimer.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import SceneKit

public protocol ImmersiveGazeTimerDelegate: class {
    func gazeTimerDidFire(withNode node: SCNNode)
}

public final class ImmersiveGazeTimer {
    
    public weak var delegate: ImmersiveGazeTimerDelegate?
    
    private weak var nodeGazed: SCNNode?
    
    private var timer: Timer!
    private let interval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.interval = timeInterval
        self.timer = generateTimer(timeInterval: timeInterval)
    }
    
    public func update(withNodeGazedAt node: SCNNode?) {
        guard let node = node else {
            if nodeGazed != nil {
                timer.invalidate()
            }
            return
        }
        
        if nodeGazed !== node {
            reset()
            nodeGazed = node
        }
    }
    
    private func reset() {
        timer.invalidate()
        timer = generateTimer(timeInterval: interval)
    }
    
    private func generateTimer(timeInterval: TimeInterval) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            if let nodeGazed = self?.nodeGazed {
                self?.delegate?.gazeTimerDidFire(withNode: nodeGazed)
                self?.nodeGazed = nil
            }
            
            self?.timer.invalidate()
        }
    }
}
