//
//  String+Extension.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 17/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

extension String {
    /// trim string which exceeds the maxChar count
    public func quickTrim(by maxCharNo : Int = 1000) -> String {
        if self.count > maxCharNo {
            return "\(self[self.startIndex..<self.index(self.startIndex, offsetBy: 80)])..."
        }
        return self;
    }
    
    
    /// return latinized character (for chinese use)
    public func latinize() -> String? {
        return self.applyingTransform(.mandarinToLatin, reverse: false)?.applyingTransform(.stripCombiningMarks, reverse: false)
    }
}
