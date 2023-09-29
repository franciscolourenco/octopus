//
//  AppDelegate.swift
//  octopus
//
//  Created by user on 27/02/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Cocoa

//@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var tabMode: Modal?
    var homerowMode: Modal?
    var launchbar: KeyToKey?
    var launchbarShift: KeyToKey?
    var capsLockMonitor: CapsLockMonitor?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "🐙"
        setupMenus()
        startTapping()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    func setupMenus() {
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            statusItem.menu = menu
    }
    private func changeStatusBarButton(number: Int) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }


    func startTapping () {
        class TabMode: Modal {

            override func entered () {
                super.entered()
                Keyboard.keyDown(key: .command)
            }
            override func exited () {
                super.exited()
                Keyboard.keyUp(key: .command)
            }

        }

        self.tabMode = TabMode(
            name: "Tabmode",
            redZone: 0.0,
//            statusIndicator: tabmodeIndicator,
            trigger: KeyEvent(key: .tab, modifiers: []),
            bindings: [
                KeyEvent(key: .l, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand]),
                KeyEvent(key: .j, modifiers: []): KeyEvent(key: .tab, modifiers: [.maskCommand, .maskShift]),
                KeyEvent(key: .y, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
                KeyEvent(key: .w, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
                KeyEvent(key: .q, modifiers: []): KeyEvent(key: .q, modifiers: [.maskCommand]),
                KeyEvent(key: .quote, modifiers: []): KeyEvent(key: .q, modifiers: [.maskCommand]),

                // Old System
                KeyEvent(key: .o, modifiers: []): KeyEvent(key: .rightArrow, modifiers: [.maskCommand, .maskAlternate]),
                KeyEvent(key: .u, modifiers: []): KeyEvent(key: .leftArrow, modifiers: [.maskCommand, .maskAlternate]),
                KeyEvent(key: .i, modifiers: []): KeyEvent(key: .backtick, modifiers: [.maskCommand]),
                KeyEvent(key: .k, modifiers: []): KeyEvent(key: .backtick, modifiers: [.maskCommand, .maskShift]),

                // New System
                KeyEvent(key: .semicolon, modifiers: []): KeyEvent(key: .t, modifiers: [.maskCommand]),
                KeyEvent(key: .h, modifiers: []): KeyEvent(key: .w, modifiers: [.maskCommand]),
                KeyEvent(key: .n, modifiers: []): KeyEvent(key: .t, modifiers: [.maskCommand, .maskShift]),
                KeyEvent(key: .slash, modifiers: []): KeyEvent(key: .f, modifiers: [.maskCommand]),

            ],
            overlaidModifiers: [
                KeyEvent(key: .f, modifiers: []): KeyOverlaidModifier(overlay: [.maskCommand], to: KeyEvent(key: .alpha1, modifiers: []))
            ]
        )

        self.homerowMode = Modal(
            name: "HomerowMode",
            redZone: 0.05,
//            statusIndicator: homerowmodeIndicator,
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
                KeyEvent(key: .backslash, modifiers: []): KeyEvent(key: .backslash, modifiers: [.maskCommand]),
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

        //        This is used as a hack to transform the caps lock into an "hyper key"
//        self.launchbar = KeyToKey(
//            fromKey: KeyEvent(key: .international, modifiers: []),
//            toKey: KeyEvent(key: .l, modifiers:[.maskCommand, .maskAlternate])
//        )
//        self.launchbarShift = KeyToKey(
//            fromKey: KeyEvent(key: .international, modifiers: [.maskShift]),
//            toKey: KeyEvent(key: .l, modifiers:[.maskCommand, .maskAlternate, .maskShift])
//        )
//        self.launchbarShift = KeyToKey(
//            fromKey: KeyEvent(key: .international, modifiers: [.maskShift]),
//            toKey: KeyEvent(key: .p, modifiers:[.maskCommand, .maskShift])
//        )

//        self.launchbar = KeyToKey(fromKey: KeyEvent(key: .m, modifiers: []), toKey: KeyEvent(key: .n, modifiers:[]))

        // self.metrics = Metrics()
    }

}

