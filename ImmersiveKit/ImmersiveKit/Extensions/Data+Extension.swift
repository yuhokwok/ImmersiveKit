//
//  Data+Extension.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 13/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

extension Data {
    /// convert JSON in Data format to String
    public func stringify() -> String? {
        guard let str = String(data: self, encoding: .utf8) else {
            return nil
        }
        return str
    }
}


