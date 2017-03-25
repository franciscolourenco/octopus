//
//  KeyEvent.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation


struct KeyEvent {
    var key: KeyCode
    var modifiers: CGEventFlags
    
    init(key: KeyCode, modifiers: CGEventFlags) {
        self.key = key
        self.modifiers = modifiers.intersection(relevantMask)
    }
}

extension KeyEvent: Hashable {
    
    var hashValue: Int {
        var hash = key.hashValue
        hash = hash ^ modifiers.rawValue.hashValue
        return hash
    }
    
    static func == (lhs: KeyEvent, rhs: KeyEvent) -> Bool {
        return lhs.key == rhs.key && lhs.modifiers == rhs.modifiers
    }
}
