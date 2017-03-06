//
//  AppDelegate.swift
//  octopus
//
//  Created by user on 27/02/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Cocoa
import Foundation


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


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
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

//            var keyCode = event.getIntegerValueField(.keyboardEventKeycode)

//            if type == .keyDown && keyCode == 0 {
//            print(keyCode, event.getIntegerValueField(.eventSourceUserData))

            if event.getIntegerValueField(.eventSourceUserData) != 1337 {

                // Trying to replicate the example from the documentation but a normal 'a' is sent instead.
                // https://developer.apple.com/reference/coregraphics/cgevent/1456564-init#discussion
                
                let event1 = CGEvent(keyboardEventSource: nil, virtualKey: Keycode.option, keyDown: true)
                let event2 = CGEvent(keyboardEventSource: nil, virtualKey: Keycode.a, keyDown: true)
                let event3 = CGEvent(keyboardEventSource: nil, virtualKey: Keycode.a, keyDown: false)
                let event4 = CGEvent(keyboardEventSource: nil, virtualKey: Keycode.option, keyDown: false)
                
                event1?.setIntegerValueField(.eventSourceUserData, value: 1337)
                event2?.setIntegerValueField(.eventSourceUserData, value: 1337)
                event3?.setIntegerValueField(.eventSourceUserData, value: 1337)
                event4?.setIntegerValueField(.eventSourceUserData, value: 1337)
                
                event1?.post(tap: .cgSessionEventTap)
                event2?.post(tap: .cgSessionEventTap)
                event3?.post(tap: .cgSessionEventTap)
                event4?.post(tap: .cgSessionEventTap)

           }
//                if keyCode == 0 {
//                    keyCode = Keycode.option
//                }
//                event.setIntegerValueField(.keyboardEventKeycode, value: keyCode)
//            }fefiwofjeifowjslfjdkfjaiorifjrowofjsldkfjeiwofż
            return Unmanaged.passRetained(event)
        }

        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: myCGEventCallback,
            userInfo: nil
            ) else {
                print("failed to create event tap")
                exit(1)
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()

    }

}
