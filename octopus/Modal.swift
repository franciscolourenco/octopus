//
//  Modal.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation

class Modal {
    var enabled: Bool = false
    var triggerPressedTimestamp = Date().timeIntervalSince1970
    var trigger: KeyEvent
    var wasUsed = false
    
    var bindings: [KeyEvent: KeyEvent] = [:]
    var overlaidModifiers: [KeyEvent: KeyOverlaidModifier]
    var activeModifiers: CGEventFlags = []
    
    var unusedOverlays: Set<KeyEvent> = []
    
    func enter() {
        enabled = true
        wasUsed = false
        triggerPressedTimestamp = Date().timeIntervalSince1970
        entered()
    }
    
    func exit() {
        enabled = false
        exited()
        activeModifiers = []
        if !wasUsed && Date().timeIntervalSince1970 - self.triggerPressedTimestamp < 1 {
            Keyboard.keyStroke(key: trigger.key)
        }
    }
    
    func entered () {
        print("Modal entered")
    }
    
    func exited () {
        print("Modal exited")
    }
    
    init(trigger: KeyEvent, bindings: [KeyEvent: KeyEvent], overlaidModifiers: [KeyEvent: KeyOverlaidModifier] = [:]) {
        self.trigger = trigger
        self.bindings = bindings
        self.overlaidModifiers = overlaidModifiers
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let thisModal = Unmanaged<Modal>.fromOpaque(userInfo!).takeUnretainedValue()
            
            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = KeyCode(rawValue: UInt16(keyCode)) {
                var modifiers = event.flags
                modifiers.remove(.maskNonCoalesced)
                
                let keyEvent = KeyEvent(key: key, modifiers: modifiers)
                
                if keyEvent == thisModal.trigger {
                    
                    if type == .keyDown {
                        if !thisModal.enabled {
                            thisModal.enter()
                        }
                        return nil
                    } else if type == .keyUp && thisModal.enabled {
                        thisModal.exit()
                        return nil
                    }
                    
                }
                
                if thisModal.enabled {
                    if type == .keyDown {
                        if let to = thisModal.bindings[keyEvent] {
                            Keyboard.keyStroke(key: to.key, modifiers: to.modifiers.union(thisModal.activeModifiers) )
                            thisModal.wasUsed = true
                            thisModal.unusedOverlays = []
                            return nil
                        }
                        
                        if let overlaidModifier = thisModal.overlaidModifiers[keyEvent] {
                            if event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
                                thisModal.unusedOverlays.insert(keyEvent)
                                thisModal.activeModifiers.insert(overlaidModifier.overlay)
                            }
                            return nil
                        }
                        
                    } else if type == .keyUp {
                        if let overlaidModifier = thisModal.overlaidModifiers[keyEvent]{
                            thisModal.activeModifiers.subtract(overlaidModifier.overlay)
                            if thisModal.unusedOverlays.contains(keyEvent) {
                                thisModal.unusedOverlays.remove(keyEvent)
                                Keyboard.keyStroke(key: overlaidModifier.to.key, modifiers: overlaidModifier.to.modifiers.union(thisModal.activeModifiers) )
                            }
                            return nil
                        }
                    }
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
