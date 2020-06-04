
//
//  Modal.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation
import Cocoa

class Modal {
    var name = "Generic Modal"
    var enabled: Bool = false
    var statusIndicator: NSButton?
    let delayBeforeEnabling = 200
    var redZone = 0.05

    var unusedKeyDown: KeyEvent? = nil
    var keyUpCount = 0
    var keyDownCount = 0

    var isUserTyping = false
    var lastTypingTimestamp = Date().timeIntervalSince1970

    var triggerPressedTimestamp = Date().timeIntervalSince1970
    var trigger: KeyEvent
    var wasUsed = false

    var bindings: [KeyEvent: KeyEvent] = [:]
    var overlaidModifiers: [KeyEvent: KeyOverlaidModifier]
    var activeModifiers: CGEventFlags = []
//    var relevantEventFields: [CGEventField] = [.keyboard​Event​Autorepeat, .keyboard​Event​Keycode, .keyboard​Event​Keyboard​Type, .event​Target​Process​Serial​Number, .event​Target​Unix​Process​ID, .event​Source​Unix​Process​ID, .event​Source​User​Data, .event​Source​User​ID, .event​Source​Group​ID, .event​Source​State​ID]

    var unusedOverlays: Set<KeyEvent> = []



    let maskToKey: [UInt64: KeyCode] = [
        CGEventFlags.maskCommand.rawValue: .command,
        CGEventFlags.maskAlternate.rawValue: .rightAlt,
        CGEventFlags.maskControl.rawValue: .rightControl,
        CGEventFlags.maskShift.rawValue: .rightShift,
    ]

    func pressVirtualModifier(modifier: CGEventFlags) {
//        Keyboard.keyDown(key: maskToKey[modifier.rawValue]!)
        activeModifiers.insert(modifier)
    }

    func releaseVirtualModifier(modifier: CGEventFlags) {
//        Keyboard.keyUp(key: maskToKey[modifier.rawValue]!)
        activeModifiers.subtract(modifier)
    }

    func enter() {
        keyDownCount = 0
        keyUpCount = 0
        enabled = true
        wasUsed = false
        triggerPressedTimestamp = Date().timeIntervalSince1970
        isUserTyping = false
        entered()
    }

    func exit() {
        enabled = false
        exited()
        activeModifiers = []
        if !wasUsed && Date().timeIntervalSince1970 - self.triggerPressedTimestamp < 1 {
            print("modal not used, sending original keystroke")
            isUserTyping = true
            Keyboard.keyStroke(key: trigger.key)
            if name == "HomerowMode" && keyDownCount == 1 && keyUpCount == 0 && unusedKeyDown != nil {
                Keyboard.keyStroke(key: (unusedKeyDown?.key)!)
            }
            unusedKeyDown = nil
        }
    }

    func inRedZone() -> Bool {
        return Date().timeIntervalSince1970 - self.triggerPressedTimestamp < redZone
    }

    func entered () {
        print(name + " entered")
        statusIndicator?.state = NSControl.StateValue.on
    }

    func exited () {
        print(name + " exited")
        statusIndicator?.state = NSControl.StateValue.off
    }

    func eventFieldsToString(event: CGEvent) -> String {
        var fieldsString = ""
        fieldsString = fieldsString + "| keyboard​Event​Autorepeat: " + String(event.getIntegerValueField(.keyboardEventAutorepeat))
        fieldsString = fieldsString + "| keyboard​Event​Keycode: " + String(event.getIntegerValueField(.keyboardEventKeycode))
        fieldsString = fieldsString + "| keyboard​Event​Keyboard​Type: " + String(event.getIntegerValueField(.keyboardEventKeyboardType))
        fieldsString = fieldsString + "| event​Target​Process​Serial​Number: " + String(event.getIntegerValueField(.eventTargetProcessSerialNumber))
        fieldsString = fieldsString + "| eventTargetUnixProcessID: " + String(event.getIntegerValueField(.eventTargetUnixProcessID))
        fieldsString = fieldsString + "| eventSourceUnixProcessID: " + String(event.getIntegerValueField(.eventSourceUnixProcessID))
        fieldsString = fieldsString + "| eventSourceUserData: " + String(event.getIntegerValueField(.eventSourceUserData))
        fieldsString = fieldsString + "| eventSourceUserID: " + String(event.getIntegerValueField(.eventSourceUserID))
        fieldsString = fieldsString + "| eventSourceGroupID: " + String(event.getIntegerValueField(.eventSourceGroupID))
        fieldsString = fieldsString + "| eventSourceStateID: " + String(event.getIntegerValueField(.eventSourceStateID))
        return fieldsString
    }
    init(name: String, redZone: Double, statusIndicator: NSButton? = nil, trigger: KeyEvent, bindings: [KeyEvent: KeyEvent], overlaidModifiers: [KeyEvent: KeyOverlaidModifier] = [:]) {
        self.name = name
        self.trigger = trigger
        self.bindings = bindings
        self.overlaidModifiers = overlaidModifiers
        self.statusIndicator = statusIndicator
        self.redZone = redZone
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let thisModal = Unmanaged<Modal>.fromOpaque(userInfo!).takeUnretainedValue()

//            print("event: ", thisModal.eventFieldsToString(event:event))

            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = KeyCode(rawValue: UInt16(keyCode)) {
                var modifiers = event.flags
                modifiers.remove(.maskNonCoalesced)

                let keyEvent = KeyEvent(key: key, modifiers: modifiers)

                

                if type == .keyDown && keyEvent == thisModal.trigger {
                    thisModal.isUserTyping = thisModal.isUserTyping && Date().timeIntervalSince1970 - thisModal.lastTypingTimestamp < 0
                    
                    if !thisModal.isUserTyping {
                        if !thisModal.enabled {
                            thisModal.enter()
                        }
                        return nil
                    } else {
                        print("User is typing, send space")
                    }
                } else if type == .keyUp && thisModal.enabled && key == thisModal.trigger.key {
                    thisModal.exit()
                    return nil
                }


                if thisModal.enabled {
                    if false && thisModal.inRedZone() && type == .keyDown {
                        print(thisModal.name + "was in redzone")
                        thisModal.exit()
                        Keyboard.keyStroke(key: key, modifiers: event.flags)
                        return nil
                    } else {
                        if type == .keyDown {
                            thisModal.keyDownCount += 1


                            if thisModal.keyDownCount > 1 || thisModal.name != "HomerowMode", let to = thisModal.bindings[keyEvent] {
                                if thisModal.unusedKeyDown != nil, let unusedTo = thisModal.bindings[thisModal.unusedKeyDown!] {
                                    Keyboard.keyStroke(key: unusedTo.key, modifiers: unusedTo.modifiers.union(thisModal.activeModifiers))
                                    thisModal.unusedKeyDown = nil
                                }
                                Keyboard.keyStroke(key: to.key, modifiers: to.modifiers.union(thisModal.activeModifiers) )
                                thisModal.wasUsed = true
                                thisModal.unusedOverlays = []
                                return nil
                            } else if thisModal.keyDownCount == 1 {
                                thisModal.unusedKeyDown = keyEvent
                            }

                            // if let to = thisModal.bindings[keyEvent] {
                            //     return nil
                            // }

                            if let overlaidModifier = thisModal.overlaidModifiers[keyEvent] {
                                if event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
                                    thisModal.unusedOverlays.insert(keyEvent)
                                    thisModal.pressVirtualModifier(modifier: overlaidModifier.overlay)
                                }
                                return nil
                            }
                            return nil




                        } else if type == .keyUp {
                            if thisModal.keyDownCount > 0 {
                                thisModal.keyUpCount += 1



                                if thisModal.name == "HomerowMode" && thisModal.keyUpCount == 1 && thisModal.keyDownCount == 1 && thisModal.unusedKeyDown != nil, let to = thisModal.bindings[keyEvent] {
                                    Keyboard.keyStroke(key: to.key, modifiers: to.modifiers.union(thisModal.activeModifiers) )
                                    thisModal.unusedKeyDown = nil
                                    thisModal.wasUsed = true
                                    thisModal.unusedOverlays = []
                                    return nil
                                }

                                if let overlaidModifier = thisModal.overlaidModifiers[keyEvent]{
                                    thisModal.releaseVirtualModifier(modifier: overlaidModifier.overlay)
                                    if thisModal.unusedOverlays.contains(keyEvent) {
                                        thisModal.unusedOverlays = []
                                        Keyboard.keyStroke(key: overlaidModifier.to.key, modifiers: overlaidModifier.to.modifiers.union(thisModal.activeModifiers) )
                                        thisModal.wasUsed = true
                                    }
                                    return nil
                                }
                            }
                        }

                    }
                }
            }

            if type == .keyUp {
                thisModal.lastTypingTimestamp = Date().timeIntervalSince1970
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
