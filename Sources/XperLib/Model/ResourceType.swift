//
//  ResourceType.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 09/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

public enum ResourceType {
    case image
    case sound
    case video
    case other
    
    public static func fromString (_ value:String) -> ResourceType {
        switch value.lowercased() {
        case "image":
            return .image
        case "sound":
            return .image
        case "video":
            return .image
        default:
            return .other
        }
    }
}
