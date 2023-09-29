//
//  KeyToKey.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation
import CoreGraphics

let relevantMask: CGEventFlags = [.maskCommand, .maskShift, .maskAlternate, .maskControl, .maskHelp, .maskAlphaShift, .maskNumericPad]


func compareFlags (a: CGEventFlags, b: CGEventFlags) -> Bool {
    return a.intersection(relevantMask) == b.intersection(relevantMask)
}


func modifierToString (mod: CGEventFlags) -> String {
    switch mod {
    case CGEventFlags.maskCommand: return "cmd"
        case CGEventFlags.maskShift: return "shift"
        case CGEventFlags.maskAlternate: return "alt"
        case CGEventFlags.maskControl: return "ctrl"
        case CGEventFlags.maskHelp: return "help"
        case CGEventFlags.maskAlphaShift: return "capslock"
        case CGEventFlags.maskNumericPad: return "numericpad"
        case CGEventFlags.maskNonCoalesced: return "nonCoalesced"
        default: return "unknown"
    }
}


//func modifiersToString(mods: CGEventFlags) -> String {
//    var flags = ""
//    for flag: CGEventFlags in relevantMask {
//        if mods.contains(flag) {
//            flags = flags + " " + modifierToString(mod: flag)
//        }
//    }
//
//    return flags
//}

class KeyToKey {
    var fromKey: KeyEvent
    var toKey: KeyEvent
    var isKeyPressed: Bool = false
    init (fromKey: KeyEvent, toKey: KeyEvent) {
        self.fromKey = fromKey
        self.toKey = toKey
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let thisKeyToKey = Unmanaged<KeyToKey>.fromOpaque(userInfo!).takeUnretainedValue()

            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = KeyCode(rawValue: UInt16(keyCode)) {
                let modifiers = event.flags
                
//                print("modifiers: ", modifiersToString(mods: modifiers), modifiers)
//                print("expected: ", modifiersToString(mods: thisKeyToKey.fromKey.modifiers), thisKeyToKey.fromKey.modifiers)
                let keyEvent = KeyEvent(key: key, modifiers: modifiers)
                
                print("autorepeat:", event.getIntegerValueField(.keyboardEventAutorepeat), "type:", type.rawValue, "pressed:", thisKeyToKey.isKeyPressed)
                if keyEvent == thisKeyToKey.fromKey {
                    
                    // prevent invalid key repeats without autoRepeat sent by Karabiner Elenents capslock
                    if thisKeyToKey.isKeyPressed && type == .keyDown && event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
                        print("double key down")
                        return nil
                    } else if !thisKeyToKey.isKeyPressed && type == .keyUp {
                        print("double key up")
                        return nil
                    }
                    thisKeyToKey.isKeyPressed = (type == .keyDown)
                    event.setIntegerValueField(.keyboardEventKeycode, value: Int64(thisKeyToKey.toKey.key.rawValue))
                    event.flags = thisKeyToKey.toKey.modifiers
                    event.setIntegerValueField(.eventSourceUserData, value: 1337)
    
                }
                
            }
            return Unmanaged.passRetained(event)
        }

        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: myCGEventCallback,
            userInfo: UnsafeMutableRawPointer(Unmanaged<AnyObject>.passUnretained(self).toOpaque())
            ) else {
                print("failed to create event tap")
                return
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()

    }
}
