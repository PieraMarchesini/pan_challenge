//
//  Screen.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

public class Screen {
    
    static var size: CGSize {
        get {
            return CGSize(width: 220, height: 220)
        }
    }
    
    static var height: CGFloat {
        get {
            return 220
        }
    }
    
    static var realSize: CGSize {
        get {
            return UIScreen.main.bounds.size
        }
    }
    
}
