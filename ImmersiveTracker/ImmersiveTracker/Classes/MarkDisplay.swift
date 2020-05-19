//
//  MarkDisplay.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 15/1/2020.
//  Copyright © 2020 ImmersiveKit Team. All rights reserved.
//

import Foundation
import SpriteKit

class MarkDisplay {
    private var _scene: SKScene!
    var mark = SKLabelNode(text: "Mark: 0")
    
    var scene: SKScene {
        get {
            return _scene
        }
    }

    init(_ size: CGSize) {
        _scene = SKScene(size: size)
    
        markSetting()
        _scene.addChild(mark)
    }
    
    func markSetting() {
        mark.position = CGPoint(x: _scene.frame.width / 2, y: 40)
        mark.horizontalAlignmentMode = .center
        mark.fontName = "AppleSDGothicNeo-Bold"
        mark.fontSize = 25
        mark.fontColor = UIColor.yellow
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
}
