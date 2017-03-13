//
//  AppDelegate.swift
//  Tentacle
//
//  Created by Pepe Becker on 11/03/2017.
//  Copyright © 2017 Pepe Becker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var tabMode : Modal? = nil

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: "baricon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        
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

