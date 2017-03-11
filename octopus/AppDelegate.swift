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

    static func ==(lhs: KeyEvent, rhs: KeyEvent) -> Bool {
        return lhs.key == rhs.key && lhs.modifiers == rhs.modifiers
    }
}


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





@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var tabMode : Modal? = nil
    
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
        class TabMode : Modal {
            override func entered () {
                Keyboard.keyDown(key: .command)
            }
            override func exited () {
                Keyboard.keyUp(key: .command)
            }
        }
        
        self.tabMode = TabMode(trigger: KeyEvent(key: .tab, modifiers: []), bindings: [
            KeyEvent(key: .l, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand]),
            KeyEvent(key: .j, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand, .maskShift]),
            KeyEvent(key: .o, modifiers: []): KeyEvent(key: .rightArrow, modifiers: [.maskCommand, .maskAlternate]),
            KeyEvent(key: .u, modifiers: []): KeyEvent(key: .leftArrow, modifiers: [.maskCommand, .maskAlternate]),
            KeyEvent(key: .i, modifiers: []): KeyEvent(key: .grave, modifiers: [.maskCommand]),
            KeyEvent(key: .k, modifiers: []): KeyEvent(key: .grave, modifiers: [.maskCommand, .maskShift])
            ])
    }

}
