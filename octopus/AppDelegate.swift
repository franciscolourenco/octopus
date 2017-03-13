//
//  AppDelegate.swift
//  octopus
//
//  Created by user on 27/02/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Cocoa
import Foundation


class Keyboard {
    static func changeKey(key: Keycode, modifiers: CGEventFlags = [], keyDown: Bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: key.rawValue, keyDown: keyDown)
        event?.setIntegerValueField(.eventSourceUserData, value: 1337)
        event?.flags = modifiers
        event?.post(tap: .cgSessionEventTap)
    }

    static func keyDown(key: Keycode, modifiers: CGEventFlags = []) {
        print("Keyboard.keyDown", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: true)
    }

    static func keyUp(key: Keycode, modifiers: CGEventFlags = []) {
        print("Keyboard.keyUp", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }

    static func keyStroke(key: Keycode, modifiers: CGEventFlags =  []) {
        print("keyStroke", key, modifiers)
        changeKey(key: key, modifiers: modifiers, keyDown: true)
        changeKey(key: key, modifiers: modifiers, keyDown: false)
    }
}

struct KeyEvent {
    var key: Keycode
    var modifiers: CGEventFlags
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

class KeyToKey {
    var fromKey: KeyEvent
    var toKey: KeyEvent
    init (fromKey: KeyEvent, toKey: KeyEvent) {
        self.fromKey = fromKey
        self.toKey = toKey

        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let thisKeyToKey = Unmanaged<KeyToKey>.fromOpaque(userInfo!).takeUnretainedValue()
            print("keycode:", keyCode)
            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = Keycode(rawValue: UInt16(keyCode)) {
                var modifiers = event.flags
                modifiers.remove(.maskNonCoalesced)

                let keyEvent = KeyEvent(key: key, modifiers: modifiers)

                if keyEvent == thisKeyToKey.fromKey {
                    event.setIntegerValueField(.keyboardEventKeycode, value: Int64(thisKeyToKey.toKey.key.rawValue))
                    event.flags = thisKeyToKey.toKey.modifiers
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

            if event.getIntegerValueField(.eventSourceUserData) != 1337, let key = Keycode(rawValue: UInt16(keyCode)) {
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





@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var tabMode: Modal? = nil
    var homerowMode: Modal? = nil
    var launchbar: KeyToKey? = nil
    var capsLockMonitor: CapsLockMonitor? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Insert code here to initialize your application
        func acquirePrivileges() -> Bool {
            let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
            let privOptions: NSDictionary = [trusted as NSString: true]
            let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
            if !accessEnabled {
                let alert = NSAlert()
                alert.messageText = "Enable Octopus"
                alert.informativeText = "Once you have enabled Octopus in System Preferences, click OK."
                alert.beginSheetModal(for: self.window, completionHandler: { response in
                    if AXIsProcessTrustedWithOptions(privOptions) {
                        print("already have priviledges")
                    } else {
                        NSApp.terminate(self)
                    }
                })
            }
            return accessEnabled
        }
        if acquirePrivileges() {
            startTapping()
        } else {
            exit(1)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func startTapping () {
        class TabMode: Modal {
            override func entered () {
                print("Tabmode entered")
                Keyboard.keyDown(key: .command)
            }
            override func exited () {
                print("Tabmode exited")
                Keyboard.keyUp(key: .command)
            }
        }

        self.tabMode = TabMode(trigger: KeyEvent(key: .tab, modifiers: []), bindings: [
            KeyEvent(key: .l, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand]),
            KeyEvent(key: .j, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand, .maskShift]),
            KeyEvent(key: .o, modifiers: []): KeyEvent(key: .rightArrow, modifiers: [.maskCommand, .maskAlternate]),
            KeyEvent(key: .u, modifiers: []): KeyEvent(key: .leftArrow, modifiers: [.maskCommand, .maskAlternate]),
            KeyEvent(key: .i, modifiers: []): KeyEvent(key: .grave, modifiers: [.maskCommand]),
            KeyEvent(key: .k, modifiers: []): KeyEvent(key: .grave, modifiers: [.maskCommand, .maskShift]),
            KeyEvent(key: .y, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
            KeyEvent(key: .w, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
            KeyEvent(key: .q, modifiers: []): KeyEvent(key: .q, modifiers: [.maskCommand]),
            KeyEvent(key: .quote, modifiers: []): KeyEvent(key: .q, modifiers: [.maskCommand])
            ])

        self.homerowMode = Modal(
            trigger: KeyEvent(key: .space, modifiers: []),
            bindings: [
                KeyEvent(key: .l, modifiers: []): KeyEvent(key: .rightArrow, modifiers: []),
                KeyEvent(key: .j, modifiers: []): KeyEvent(key: .leftArrow, modifiers: []),
                KeyEvent(key: .i, modifiers: []): KeyEvent(key: .upArrow, modifiers: []),
                KeyEvent(key: .k, modifiers: []): KeyEvent(key: .downArrow, modifiers: []),
                KeyEvent(key: .u, modifiers: []): KeyEvent(key: .backspace, modifiers: []),
                KeyEvent(key: .o, modifiers: []): KeyEvent(key: .space, modifiers: []),
                KeyEvent(key: .p, modifiers: []): KeyEvent(key: .delete, modifiers: []),
                KeyEvent(key: .semicolon, modifiers: []): KeyEvent(key: .returnKey, modifiers: []),
                KeyEvent(key: .quote, modifiers: []): KeyEvent(key: .escape, modifiers: []),
                KeyEvent(key: .h, modifiers: []): KeyEvent(key: .z, modifiers: [.maskCommand]),
                KeyEvent(key: .n, modifiers: []): KeyEvent(key: .z, modifiers: [.maskCommand, .maskShift]),
                KeyEvent(key: .w, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
                KeyEvent(key: .e, modifiers: []): KeyEvent(key: .f, modifiers: [.maskCommand]),
                KeyEvent(key: .r, modifiers: []): KeyEvent(key: .r, modifiers: [.maskCommand]),
                KeyEvent(key: .t, modifiers: []): KeyEvent(key: .t, modifiers: [.maskCommand]),
                KeyEvent(key: .slash, modifiers: []): KeyEvent(key: .slash, modifiers: [.maskCommand]),

            ],
            overlaidModifiers: [
                KeyEvent(key: .a, modifiers: []): KeyOverlaidModifier(overlay: [.maskShift], to: KeyEvent(key: .s, modifiers: [.maskControl])),
                KeyEvent(key: .s, modifiers: []): KeyOverlaidModifier(overlay: [.maskControl], to: KeyEvent(key: .x, modifiers: [.maskCommand])),
                KeyEvent(key: .d, modifiers: []): KeyOverlaidModifier(overlay: [.maskAlternate], to: KeyEvent(key: .c, modifiers: [.maskCommand])),
                KeyEvent(key: .f, modifiers: []): KeyOverlaidModifier(overlay: [.maskCommand], to: KeyEvent(key: .v, modifiers: [.maskCommand])),
                KeyEvent(key: .g, modifiers: []): KeyOverlaidModifier(
                    overlay: [.maskCommand, .maskControl, .maskAlternate, .maskShift],
                    to: KeyEvent(key: .d, modifiers: [.maskControl, .maskShift]))

            ]
        )
//        self.launchbar = KeyToKey(fromKey: KeyEvent(key: .capsLock, modifiers: []), toKey: KeyEvent(key: .l, modifiers:[.maskCommand, .maskAlternate]))
//        self.capsLockMonitor = CapsLockMonitor()
    }
}
