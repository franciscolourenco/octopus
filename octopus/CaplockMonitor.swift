//
//  CaplockMonitor.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation
import CoreGraphics


class CapsLockMonitor {
    var isCapsLockOn = false
    
    init () {
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            
            print("flags changed")
            if event.flags.contains(.maskAlphaShift) {
                event.flags.remove(.maskAlphaShift)
                Keyboard.keyUp(key: .capsLock)
                print("capslock was activated")
            }
            
            
            //
            //            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            //            let thisCapsLockMonitor = Unmanaged<KeyToKey>.fromOpaque(userInfo!).takeUnretainedValue()
            //            print("keycode:", keyCode)
            //            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = Keycode(rawValue: UInt16(keyCode)) {
            //                var modifiers = event.flags
            //                modifiers.remove(.maskNonCoalesced)
            //
            //                let keyEvent = KeyEvent(key: key, modifiers: modifiers)
            //
            //                if keyEvent == thisCapsLockMonitor.fromKey {
            //                    event.setIntegerValueField(.keyboardEventKeycode, value: Int64(thisCapsLockMonitor.toKey.key.rawValue))
            //                    event.flags = thisCapsLockMonitor.toKey.modifiers
            //                }
            //            }
            return Unmanaged.passRetained(event)
        }
        
        let eventMask = (1 << CGEventType.flagsChanged.rawValue)
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
