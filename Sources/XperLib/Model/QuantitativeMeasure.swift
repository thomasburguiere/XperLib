//
//  QuantitativeMeasure.swift
//  Xper
//
//  Created by Thomas Burguiere on 11/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class QuantitativeMeasure : Hashable{
    open var max: Double?
    open var min: Double?
    open var uMethUpper: Double?
    open var uMethLower: Double?
    
    open var mean: Double?
    open var sd: Double?

    open var minInclusive: Bool = true
    open var maxInclusive: Bool = true

    public init(){}
    public init(mean: Double){
        self.mean = mean
    }


    open var computedMin: Double? {
        if min != nil {
            return min!
        } else if uMethLower != nil {
            return uMethLower
        } else if sd != nil && mean != nil {
            return mean! - 2 *  sd!
        }
        return nil
    }

    open var computedMax: Double? {
        if max != nil {
            return max!
        } else if uMethUpper != nil {
            return uMethUpper
        } else if sd != nil && mean != nil {
            return mean! + 2 *  sd!
        }
        return nil
    }

    open var isFilled: Bool {
        return computedMax != nil && computedMin != nil
    }

    open func contains(_ otherQm: QuantitativeMeasure?) -> Bool {
        if otherQm == nil {
            return false;
        } else if (isFilled && otherQm!.isFilled){
            if(maxInclusive) {
                if(otherQm?.computedMin >= computedMin && otherQm?.computedMin <= computedMax) ||
                   (otherQm?.computedMax >= computedMin && otherQm?.computedMax <= computedMax) {
                    return true
                }
            } else {
                if (otherQm?.computedMin >= computedMin && otherQm?.computedMin < computedMax) ||
                    (otherQm?.computedMax >= computedMax && otherQm?.computedMax < computedMax){
                    return true
                }
            }
        }
        return false
    }

    open func isGreaterThan(_ value: Double, comparingIntervals: Bool) -> Bool? {
        if isFilled  {
            if(comparingIntervals) {
                return computedMin > value
            }
            return mean != nil ? mean > value : false
        }
        return nil
    }

    open func isGreaterThan(_ otherQm: QuantitativeMeasure, comparingIntervals: Bool, strictly: Bool) -> Bool? {
        if isFilled && otherQm.isFilled {
            if comparingIntervals {
                if strictly {
                    return computedMin > otherQm.computedMax
                } else {
                    return computedMin >= otherQm.computedMax
                }
            } else {
                return mean != nil && otherQm.mean != nil ? mean > otherQm.mean : nil
            }
        }
        return nil
    }

    public static func ==(lhs: QuantitativeMeasure, rhs: QuantitativeMeasure) -> Bool {
        if (lhs.mean != rhs.mean) {
            return false
        }
        return true
    }

    public func hash(into hasher: inout Hasher) {
        if let meanVal = self.mean {
            hasher.combine(meanVal)
        } else{
            hasher.combine(0)
        }
    }
}
