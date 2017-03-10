//
//  Keycodes.swift
//  octopus
//
//  Created by user on 02/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

//
//  Keycodes.swift
//  MUT20XX
//
//  Copyright © 2017 iDevGames. All rights reserved.
//
import Foundation


struct KeycodeStruct {
    var number : UInt16;
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    static let returnKey                 : UInt16 = 0x24
    static let enter                     : UInt16 = 0x4C
    static let tab                       : UInt16 = 0x30
    static let space                     : UInt16 = 0x31
    static let delete                    : UInt16 = 0x33
    static let escape                    : UInt16 = 0x35
    static let command                   : UInt16 = 0x37
    static let shift                     : UInt16 = 0x38
    static let capsLock                  : UInt16 = 0x39
    static let option                    : UInt16 = 0x3A
    static let control                   : UInt16 = 0x3B
    static let rightShift                : UInt16 = 0x3C
    static let rightOption               : UInt16 = 0x3D
    static let rightControl              : UInt16 = 0x3E
    static let leftArrow                 : UInt16 = 0x7B
    static let rightArrow                : UInt16 = 0x7C
    static let downArrow                 : UInt16 = 0x7D
    static let upArrow                   : UInt16 = 0x7E
    static let volumeUp                  : UInt16 = 0x48
    static let volumeDown                : UInt16 = 0x49
    static let mute                      : UInt16 = 0x4A
    static let help                      : UInt16 = 0x72
    static let home                      : UInt16 = 0x73
    static let pageUp                    : UInt16 = 0x74
    static let forwardDelete             : UInt16 = 0x75
    static let end                       : UInt16 = 0x77
    static let pageDown                  : UInt16 = 0x79
    static let function                  : UInt16 = 0x3F
    static let f1                        : UInt16 = 0x7A
    static let f2                        : UInt16 = 0x78
    static let f4                        : UInt16 = 0x76
    static let f5                        : UInt16 = 0x60
    static let f6                        : UInt16 = 0x61
    static let f7                        : UInt16 = 0x62
    static let f3                        : UInt16 = 0x63
    static let f8                        : UInt16 = 0x64
    static let f9                        : UInt16 = 0x65
    static let f10                       : UInt16 = 0x6D
    static let f11                       : UInt16 = 0x67
    static let f12                       : UInt16 = 0x6F
    static let f13                       : UInt16 = 0x69
    static let f14                       : UInt16 = 0x6B
    static let f15                       : UInt16 = 0x71
    static let f16                       : UInt16 = 0x6A
    static let f17                       : UInt16 = 0x40
    static let f18                       : UInt16 = 0x4F
    static let f19                       : UInt16 = 0x50
    static let f20                       : UInt16 = 0x5A
    
    // US-ANSI Keyboard Positions
    // eg. These key codes are for the physical key (in any keyboard layout)
    // at the location of the named key in the US-ANSI layout.
    static let a                         : UInt16 = 0x00
    static let b                         : UInt16 = 0x0B
    static let c                         : UInt16 = 0x08
    static let d                         : UInt16 = 0x02
    static let e                         : UInt16 = 0x0E
    static let f                         : UInt16 = 0x03
    static let g                         : UInt16 = 0x05
    static let h                         : UInt16 = 0x04
    static let i                         : UInt16 = 0x22
    static let j                         : UInt16 = 0x26
    static let k                         : UInt16 = 0x28
    static let l                         : UInt16 = 0x25
    static let m                         : UInt16 = 0x2E
    static let n                         : UInt16 = 0x2D
    static let o                         : UInt16 = 0x1F
    static let p                         : UInt16 = 0x23
    static let q                         : UInt16 = 0x0C
    static let r                         : UInt16 = 0x0F
    static let s                         : UInt16 = 0x01
    static let t                         : UInt16 = 0x11
    static let u                         : UInt16 = 0x20
    static let v                         : UInt16 = 0x09
    static let w                         : UInt16 = 0x0D
    static let x                         : UInt16 = 0x07
    static let y                         : UInt16 = 0x10
    static let z                         : UInt16 = 0x06
    
    static let zero                      : UInt16 = 0x1D
    static let one                       : UInt16 = 0x12
    static let two                       : UInt16 = 0x13
    static let three                     : UInt16 = 0x14
    static let four                      : UInt16 = 0x15
    static let five                      : UInt16 = 0x17
    static let six                       : UInt16 = 0x16
    static let seven                     : UInt16 = 0x1A
    static let eight                     : UInt16 = 0x1C
    static let nine                      : UInt16 = 0x19
    
    static let equals                    : UInt16 = 0x18
    static let minus                     : UInt16 = 0x1B
    static let semicolon                 : UInt16 = 0x29
    static let apostrophe                : UInt16 = 0x27
    static let comma                     : UInt16 = 0x2B
    static let period                    : UInt16 = 0x2F
    static let forwardSlash              : UInt16 = 0x2C
    static let backslash                 : UInt16 = 0x2A
    static let grave                     : UInt16 = 0x32
    static let leftBracket               : UInt16 = 0x21
    static let rightBracket              : UInt16 = 0x1E
    
    static let keypadDecimal             : UInt16 = 0x41
    static let keypadMultiply            : UInt16 = 0x43
    static let keypadPlus                : UInt16 = 0x45
    static let keypadClear               : UInt16 = 0x47
    static let keypadDivide              : UInt16 = 0x4B
    static let keypadEnter               : UInt16 = 0x4C
    static let keypadMinus               : UInt16 = 0x4E
    static let keypadEquals              : UInt16 = 0x51
    static let keypad0                   : UInt16 = 0x52
    static let keypad1                   : UInt16 = 0x53
    static let keypad2                   : UInt16 = 0x54
    static let keypad3                   : UInt16 = 0x55
    static let keypad4                   : UInt16 = 0x56
    static let keypad5                   : UInt16 = 0x57
    static let keypad6                   : UInt16 = 0x58
    static let keypad7                   : UInt16 = 0x59
    static let keypad8                   : UInt16 = 0x5B
    static let keypad9                   : UInt16 = 0x5C
}


// TODO: Not sure if there's any point, but would be nice if it was platform-agnostic?
// Might be better for them to be their own values with a "FromOSXKeyCode" function
enum Keycode: UInt16 {
    
    // MARK: ANSI Key Codes, including modifier keys
    // The values match Apple's ANSI key codes defined in Carbon/HIToolbox/Events.h
    case a              = 0x00
    case b              = 0x0B
    case c              = 0x08
    case d              = 0x02
    case e              = 0x0E
    case f              = 0x03
    case g              = 0x05
    case h              = 0x04
    case i              = 0x22
    case j              = 0x26
    case k              = 0x28
    case l              = 0x25
    case m              = 0x2E
    case n              = 0x2D
    case o              = 0x1F
    case p              = 0x23
    case q              = 0x0C
    case r              = 0x0F
    case s              = 0x01
    case t              = 0x11
    case u              = 0x20
    case v              = 0x09
    case w              = 0x0D
    case x              = 0x07
    case y              = 0x10
    case z              = 0x06
    
    case alpha1         = 0x12
    case alpha2         = 0x13
    case alpha3         = 0x14
    case alpha4         = 0x15
    case alpha5         = 0x17
    case alpha6         = 0x16
    case alpha7         = 0x1A
    case alpha8         = 0x1C
    case alpha9         = 0x19
    case alpha0         = 0x1D
    
    case grave          = 0x32
    case minus          = 0x1B
    case equals         = 0x18
    case leftBracket    = 0x21
    case rightBracket   = 0x1E
    case backslash      = 0x2A
    case semicolon      = 0x29
    case quote          = 0x27
    case comma          = 0x2B
    case period         = 0x2F
    case slash          = 0x2C
    
    case numpadDecimal  = 0x41
    case numpadMultiply = 0x43
    case numpadPlus     = 0x45
    case numpadClear    = 0x47
    case numpadDivide   = 0x4B
    case numpadEnter    = 0x4C
    case numpadMinus    = 0x4E
    case numpadEquals   = 0x51
    case numpad0        = 0x52
    case numpad1        = 0x53
    case numpad2        = 0x54
    case numpad3        = 0x55
    case numpad4        = 0x56
    case numpad5        = 0x57
    case numpad6        = 0x58
    case numpad7        = 0x59
    case numpad8        = 0x5B
    case numpad9        = 0x5C
    
    case returnKey      = 0x24
    case tab            = 0x30
    case space          = 0x31
    case backspace      = 0x33
    case escape         = 0x35
    case leftShift      = 0x38
    case rightShift     = 0x3C
    case capsLock       = 0x39
    case function       = 0x3F
    case leftControl    = 0x3B
    case rightControl   = 0x3E
    case leftAlt        = 0x3A
    case rightAlt       = 0x3D
    case command        = 0x37
    case delete         = 0x75
    case home           = 0x73
    case end            = 0x77
    case pageUp         = 0x74
    case pageDown       = 0x79
    case leftArrow      = 0x7B
    case rightArrow     = 0x7C
    case downArrow      = 0x7D
    case upArrow        = 0x7E
    
    case f1             = 0x7A
    case f2             = 0x78
    case f3             = 0x63
    case f4             = 0x76
    case f5             = 0x60
    case f6             = 0x61
    case f7             = 0x62
    case f8             = 0x64
    case f9             = 0x65
    case f10            = 0x6D
    case f11            = 0x67
    case f12            = 0x6F
}
