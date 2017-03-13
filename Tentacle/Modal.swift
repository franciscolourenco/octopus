//
//  Modal.swift
//  Tentacle
//
//  Created by Pepe Becker on 11/03/2017.
//  Copyright © 2017 Pepe Becker. All rights reserved.
//

import Cocoa

class Modal {
    var on: Bool = false
    var triggerPressedTimestamp = Date().timeIntervalSince1970
    var trigger : KeyEvent
    var wasUsed = false
    
    var bindings: [KeyEvent: KeyEvent] = [:]
    
    func enter() {
        on = true
        wasUsed = false
        triggerPressedTimestamp = Date().timeIntervalSince1970
        entered()
    }
    
    func exit() {
        on = false
        exited()
        if !wasUsed && Date().timeIntervalSince1970 - self.triggerPressedTimestamp < 1{
            Keyboard.keyStroke(key: trigger.key)
        }
    }
    
    func entered () {
    }
    
    func exited () {
    }
    
    init(trigger: KeyEvent, bindings: [KeyEvent: KeyEvent]) {
        self.trigger = trigger
        self.bindings = bindings
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let thisModal = Unmanaged<Modal>.fromOpaque(userInfo!).takeUnretainedValue()
            
            if event.getIntegerValueField(.eventSourceUserData) != 1337 {
                var modifiers = event.flags
                modifiers.remove(.maskNonCoalesced)
                
                
                if let key = Keycode(rawValue: UInt16(keyCode)), KeyEvent(key: key, modifiers: modifiers) == thisModal.trigger {
                    if type == .keyDown && event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
                        thisModal.enter()
                    } else if type == .keyUp {
                        thisModal.exit()
                    }
                    return nil
                }
                
                if thisModal.on && type == .keyDown {
                    if let to = thisModal.bindings[KeyEvent(key: Keycode(rawValue: UInt16(keyCode))!, modifiers: modifiers)] {
                        Keyboard.keyStroke(key: to.key, modifiers: to.modifiers )
                        thisModal.wasUsed = true
                        return nil
                    }
                }
            }
            
            //                event.setIntegerValueField(.keyboardEventKeycode, value: keyCode)
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
