//
//  FileLoader.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

struct FileLoader {
    
    func loadDictionary(fromFileNamed filename: String, extension: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: `extension`),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        
        return dictionary
    }
    
    func loadDictionary(fromJsonNamed name: String) -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        return dictionary
    }
}

