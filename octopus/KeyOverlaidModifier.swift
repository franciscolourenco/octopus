//
//  KeyOverlaidModifier.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation

class KeyOverlaidModifier: Hashable {
    var overlay: CGEventFlags
    var to: KeyEvent
    var triggerPressedTimestamp = Date().timeIntervalSince1970
    var wasUsed = false
    
    var hashValue: Int {
        return overlay.rawValue.hashValue ^ to.hashValue
    }
    
    static func == (lhs: KeyOverlaidModifier, rhs: KeyOverlaidModifier) -> Bool {
        return lhs.overlay == rhs.overlay && lhs.to == rhs.to
    }
    
    init(overlay: CGEventFlags, to: KeyEvent) {
        self.overlay = overlay
        self.to = to
    }
}
