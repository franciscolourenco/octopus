//
//  KeyEvent.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation
import CoreGraphics


struct KeyEvent {
    var key: KeyCode
    var modifiers: CGEventFlags
    
    init(key: KeyCode, modifiers: CGEventFlags) {
        self.key = key
        self.modifiers = modifiers.intersection(relevantMask)
    }
    func contains(otherKeyEvent: KeyEvent) -> Bool {
        return self.key == otherKeyEvent.key && self.modifiers.contains(otherKeyEvent.modifiers)
    }
}

extension KeyEvent: Hashable {
    static func == (lhs: KeyEvent, rhs: KeyEvent) -> Bool {
        return lhs.key == rhs.key && lhs.modifiers == rhs.modifiers
    }
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(modifiers.rawValue)
    }
}
