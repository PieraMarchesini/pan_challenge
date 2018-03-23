//
//  Device.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import Foundation

enum Device {
    
    case iPhone
    case iPhoneX
    case iPad
    
    static var isIphone: Bool {
        get {
            return Screen.realSize.width < 768
        }
    }
    
    static var isIpad: Bool {
        get {
            return Screen.realSize.width >= 768
        }
    }
    
    static var isIpad12: Bool {
        get {
            return Screen.realSize.width >= 1000
        }
    }
    
    static var isIphoneX: Bool {
        get {
            return Screen.realSize.height == 812
        }
    }
    
    static var thisDevice: Device {
        get {
            if isIphone { return .iPhone }
            else if isIpad { return .iPad }
            else { return .iPhoneX }
        }
    }
}
