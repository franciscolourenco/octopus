//
//  Keyboard.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation

class Keyboard {
    static func changeKey(key: KeyCode, modifiers: CGEventFlags = [], keyDown: Bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: key.rawValue, keyDown: keyDown)
        event?.setIntegerValueField(.eventSourceUserData, value: 1337)
        event?.flags = modifiers
        event?.post(tap: .cgSessionEventTap)
    }

    static func keyDown(key: KeyCode, modifiers: CGEventFlags = []) {
        print("Keyboard.keyDown", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: true)
    }

    static func keyUp(key: KeyCode, modifiers: CGEventFlags = []) {
        print("Keyboard.keyUp", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }

    static func keyStroke(key: KeyCode, modifiers: CGEventFlags =  []) {
        print("keyStroke", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: true)
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }
}
