//
//  Modal.swift
//  octopus
//
//  Created by user on 13/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation
import Cocoa


func getCharacter(event: CGEvent) -> String {
    var length = 0
    var chars = Array(repeating: UniChar(0), count: 1)
    event.keyboardGetUnicodeString(maxStringLength: 1, actualStringLength: &length, unicodeString: &chars)
    return NSString(characters:chars, length: length) as String
}

class Metrics {
    var isSpacePressed = false
    var spaceTimeStamp = Date().timeIntervalSince1970
    var lastKeyPressedTimestamp = Date().timeIntervalSince1970
    var lastKeyPressed = ""
    var spaceKeyCode = Int64(KeyCode.space.rawValue)
    var pressCount = 0
    var overlapCount = 0
    
    
    var runLoopSource: CFRunLoopSource? = nil
    let outputFile: OutputStream
    
    
    
    init() {
        let fileURL = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("space-overlap.txt")
        
        outputFile = OutputStream(url: fileURL, append: true)!
        outputFile.open()
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            
            let myself = Unmanaged<Metrics>.fromOpaque(userInfo!).takeUnretainedValue()
            
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            
            if type == .keyDown {
                myself.pressCount += 1
            }
            
            if keyCode == myself.spaceKeyCode && type == .keyDown {
                myself.spaceTimeStamp = Date().timeIntervalSince1970
                myself.isSpacePressed = true
            } else if keyCode == myself.spaceKeyCode && type == .keyUp {
                myself.isSpacePressed = false
            } else if myself.isSpacePressed && type == .keyDown {
                myself.overlapCount += 1
                let timeSinceSpacePress = Date().timeIntervalSince1970 - myself.spaceTimeStamp
                let timeSinceLastKeyPress = myself.spaceTimeStamp - myself.lastKeyPressedTimestamp
                let char = getCharacter(event: event)
                let text = "Overlap #\(myself.overlapCount)(\(myself.pressCount)): '\(char)' \(timeSinceSpacePress)s after space  | '\(myself.lastKeyPressed)' \(timeSinceLastKeyPress)s before space \n"
                let _ = myself.outputFile.write(text)
            } else {
                myself.lastKeyPressedTimestamp = Date().timeIntervalSince1970
                myself.lastKeyPressed = getCharacter(event: event)
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
        
        self.runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
        
    }
    
}



