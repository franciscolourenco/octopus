//
//  AppDelegate.swift
//  Tentacle
//
//  Created by Pepe Becker on 11/03/2017.
//  Copyright © 2017 Pepe Becker. All rights reserved.
//

import Cocoa

var appIsEnabled = true

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusLabelItem: NSMenuItem!
    @IBOutlet weak var checkForUpdatesItem: NSMenuItem!
    @IBOutlet weak var toggleItem: NSMenuItem!
    @IBOutlet weak var openHelpItem: NSMenuItem!
    @IBOutlet weak var quitItem: NSMenuItem!
    @IBOutlet weak var helpWindow: NSWindow!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var tabMode : Modal? = nil
    
    func checkForUpdates() {
        let alert = NSAlert()
        alert.messageText = "You're up-to-date!"
        alert.informativeText = "Tentacle 1.0 is currently the newest version available."
        alert.addButton(withTitle: "OK")
        alert.buttons[0].isHighlighted = true
        alert.runModal()
    }
    
    func toggle() {
        if appIsEnabled {
            self.toggleItem.title = "Enable Tentacle"
            appIsEnabled = false
            self.statusLabelItem.title = "Status: Disabled"
        } else {
            self.toggleItem.title = "Disable Tentacle"
            appIsEnabled = true
            self.statusLabelItem.title = "Status: Enabled"
        }
    }
    
    func openHelp() {
        let alert = NSAlert()
        alert.messageText = "Go find help somewhere else!"
        alert.informativeText = "I haven't figured out yet how to show/hide a help window."
        alert.addButton(withTitle: "OK")
        alert.buttons[0].isHighlighted = true
        alert.runModal()
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: "baricon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        
        self.checkForUpdatesItem.target = self
        self.checkForUpdatesItem.action = #selector(checkForUpdates)
        
        self.toggleItem.target = self
        self.toggleItem.action = #selector(toggle)
        
        self.openHelpItem.target = self
        self.openHelpItem.action = #selector(openHelp)
        
        self.quitItem.target = self
        self.quitItem.action = #selector(quit)
        
        
        func acquirePrivileges() -> Bool {
            let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
            let privOptions: NSDictionary = [trusted as NSString: true]
            let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
            if !accessEnabled {
                let alert = NSAlert()
                alert.messageText = "Enable Octopus"
                alert.informativeText = "Once you have enabled Octopus in System Preferences, click OK."
//                alert.beginSheetModal(for: self.window, completionHandler: { response in
                    if AXIsProcessTrustedWithOptions(privOptions) {
                        print("already have priviledges")
                    } else {
                        NSApp.terminate(self)
                    }
//                })
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

    func startTapping() {
        print("startTapping()")
        class TabMode : Modal {
            override func entered () {
                print("entered()")
                Keyboard.keyDown(key: .command)
            }
            override func exited () {
                print("exited()")
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

