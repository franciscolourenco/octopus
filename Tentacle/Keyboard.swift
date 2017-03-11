//
//  Keyboard.swift
//  Tentacle
//
//  Created by Pepe Becker on 11/03/2017.
//  Copyright © 2017 Pepe Becker. All rights reserved.
//

import Cocoa

class Keyboard {
    static func changeKey(key: Keycode, modifiers: CGEventFlags = [], keyDown: Bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: key.rawValue, keyDown: keyDown)
        event?.setIntegerValueField(.eventSourceUserData, value: 1337)
        event?.flags = modifiers
        event?.post(tap: .cgSessionEventTap)
    }
    
    static func keyDown(key: Keycode, modifiers: CGEventFlags = []) {
        changeKey(key: key, modifiers: modifiers, keyDown: true)
    }
    
    static func keyUp(key: Keycode, modifiers: CGEventFlags = []) {
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }
    
    static func keyStroke(key: Keycode, modifiers: CGEventFlags =  []) {
        changeKey(key: key, modifiers: modifiers, keyDown: true)
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }
}
