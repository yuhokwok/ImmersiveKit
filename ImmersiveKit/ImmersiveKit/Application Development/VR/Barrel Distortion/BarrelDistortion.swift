//
//  BarrelDistortion.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import SceneKit
public class BarrelDistortion {
    enum Constant {
        enum Shader {
            static let glslFilename = "barrel_dist_glsl"
            static let mlslFilename = "barrel_dist_mlsl"
        }
    }
    
    public static var shared : SCNTechnique? {
        guard let dictionary = FileLoader().loadDictionary(fromJsonNamed: Constant.Shader.mlslFilename),
              let barrelDistortion = SCNTechnique(dictionary: dictionary) else {
            assertionFailure("Could not load technique dictionary.")
            return nil
        }
        return barrelDistortion
    }
}
