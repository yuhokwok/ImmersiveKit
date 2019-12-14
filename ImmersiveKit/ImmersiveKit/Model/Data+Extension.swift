//
//  Data+Extension.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 13/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

extension Data {
    /// convert JSON in Data format to String
    public func stringifyFromJSONData() -> String? {
        guard let str = String(data: self, encoding: .utf8) else {
            return nil
        }
        return str
    }
}

extension String {
    public func quickTrim() -> String {
        if self.count > 1000 {
            return "\(self[self.startIndex..<self.index(self.startIndex, offsetBy: 80)])..."
        }
        return self;
    }
}
