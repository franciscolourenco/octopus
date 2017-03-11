//
//  KeyEvent.swift
//  Tentacle
//
//  Created by Pepe Becker on 11/03/2017.
//  Copyright © 2017 Pepe Becker. All rights reserved.
//

import Cocoa

struct KeyEvent {
    var key: Keycode
    var modifiers: CGEventFlags
}

extension KeyEvent: Hashable {
    var hashValue: Int {
        var hash = key.hashValue
        hash = hash ^ modifiers.rawValue.hashValue
        return hash
    }
    
    static func ==(lhs: KeyEvent, rhs: KeyEvent) -> Bool {
        return lhs.key == rhs.key && lhs.modifiers == rhs.modifiers
    }
}
