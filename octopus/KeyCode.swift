//
//  Keycodes.swift
//  octopus
//
//  Created by user on 02/03/17.
//  Copyright © 2017 Betafabric. All rights reserved.
//

import Foundation

enum KeyCode: UInt16 {
    
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
    
    case backtick          = 0x32
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
