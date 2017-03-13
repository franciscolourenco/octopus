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
            KeyEvent(key: .i, modifiers: []): KeyEvent(key: .backtick, modifiers: [.maskCommand]),
            KeyEvent(key: .k, modifiers: []): KeyEvent(key: .backtick, modifiers: [.maskCommand, .maskShift]),
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
