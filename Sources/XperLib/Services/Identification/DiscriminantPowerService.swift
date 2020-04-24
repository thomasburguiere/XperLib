//
//  IdentificationService.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 06/05/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class DiscriminantPowerService {
    
    public static func getDiscriminantPower(
        descriptor: Descriptor,
        items: [Item],
        value: Double,
        scoreMethod: ScoreMethod,
        dependencyTree: Tree<Descriptor>,
        considerChildScores: Bool,
        withGlobalWeights: Bool
        ) -> Double{
        
        var returnValue: Double = 0
        var cpt: Int = 0
        
        let descriptorNode = dependencyTree.nodes.filter{$0.object === descriptor}.first
        if descriptor.isQuantitative {
            for item1 in items {
                for item2 in items {
                    let tmp = compareItemsByQuantitativeDescriptor(descriptor: descriptor as! QuantitativeDescriptor, item1: item1, item2: item2, descriptorNode: descriptorNode!, scoreMethod: scoreMethod)
                    if tmp >= 0 {
                        returnValue += tmp
                        cpt += 1
                    }
                }
            }
        } else if descriptor.isCategorical {
            if (descriptor as! CategoricalDescriptor).states.count == 0 {
                returnValue += 0
                cpt += 1
            } else {
                for item1 in items {
                    for item2 in items {
                        let tmp = compareItemsByCategoricalDescriptor(descriptor: descriptor as! CategoricalDescriptor, item1: item1, item2: item2, descriptorNode: descriptorNode!, scoreMethod: scoreMethod)
                        if tmp >= 0 {
                            returnValue += tmp
                            cpt += 1
                        }
                    }
                }
            }
        }
        
        // to normalize the number
        if (returnValue != 0 && cpt != 0)        {
            returnValue = returnValue / Double(cpt);
        }
        
        if (withGlobalWeights) {
            if (returnValue != 0) {
                returnValue += Double(descriptor.globalWeight);
            } else {
                returnValue = -1;
            }
        }
        
         // recursive DP calculation of child descriptors
        if considerChildScores && descriptorNode != nil {
            for node in (descriptorNode?.getChildNodes())! {
                let childDescriptor = node.object
                returnValue = max(value, getDiscriminantPower(descriptor: childDescriptor!, items: items, value: returnValue, scoreMethod: scoreMethod, dependencyTree: dependencyTree, considerChildScores: considerChildScores, withGlobalWeights: withGlobalWeights))
            }
        }
        
        return max(value, returnValue)
    }
    
    public static func compareItemsByQuantitativeDescriptor(
        descriptor: QuantitativeDescriptor,
        item1: Item,
        item2: Item,
        descriptorNode: Node<Descriptor>,
        scoreMethod: ScoreMethod
        ) -> Double {
        
        if isInnaplicable(item: item1, descriptorNode: descriptorNode) || isInnaplicable(item: item2, descriptorNode: descriptorNode) {
            return -1
        }
        let des1 = item1.itemDescription?.descriptionElements[descriptor]!
        let des2 = item2.itemDescription?.descriptionElements[descriptor]!
        
        let qm1 = des1?.quantitativeMeasure
        let qm2 = des2?.quantitativeMeasure
        
        var commonPercentage: Double
        if qm1 == nil || qm2 == nil {
            return 0
        } else {
            if qm1?.computedMin == nil || qm1?.computedMax == nil || qm2?.computedMax == nil || qm2?.computedMin == nil {
                return 0
            } else {
                commonPercentage = calculateCommonPercentage((qm1?.computedMin)!, max1: (qm1?.computedMax)!, min2: (qm2?.computedMin)!, max2: (qm2?.computedMax)!)
            }
        }
        if (commonPercentage <= 0) {
            commonPercentage = 0
        }
        switch scoreMethod {
        case .sokalAndMichener:
            return 1 - (commonPercentage / 100)
        case .jackard:
            return 1 - (commonPercentage / 100)
        default:
            if ((commonPercentage <= 0)) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    
    public static func compareItemsByCategoricalDescriptor (
        descriptor: CategoricalDescriptor,
        item1: Item,
        item2: Item,
        descriptorNode: Node<Descriptor>,
        scoreMethod: ScoreMethod) -> Double {
        
        if isInnaplicable(item: item1, descriptorNode: descriptorNode) || isInnaplicable(item: item2, descriptorNode: descriptorNode) {
            return -1
        }
        
        
        let des1 = item1.itemDescription?.descriptionElements[descriptor]!
        let des2 = item2.itemDescription?.descriptionElements[descriptor]!
        
        var item1States = des1!.selectedStates
        var item2States = des2!.selectedStates
        let allStates = descriptor.states
        if des1!.unknown {
            item1States = allStates
        }
        if des2!.unknown {
            item2States = allStates
        }
        
        var commonPresent = 0.0
        var commonAbsent = 0.0
        var other = 0.0
        for state in allStates {
            if item1States.contains(where: {$0 === state}) {
                if item2States.contains(where: {$0 === state}) {
                    commonPresent += 1
                } else {
                    other += 1
                }
            } else {
                if item2States.contains(where: {$0 === state}) {
                    other += 1
                } else {
                    commonAbsent += 1
                }
            }
        }
        
        switch scoreMethod {
        case .sokalAndMichener:
            return 1 - ((commonPresent + commonAbsent) / (commonPresent + commonAbsent + other))
        case .jackard:
            return 1 - (commonPresent / (commonPresent + other))
        default:
            if ((commonPresent == 0) && (other > 0)) {
                return 1
            } else {
                return 0
            }
        }
        
        
    }
    
    static func isInnaplicable(item: Item, descriptorNode: Node<Descriptor>? ) -> Bool {
        if descriptorNode != nil && descriptorNode!.getParentNode() != nil {
            let innapStates = descriptorNode?.getInapplicableStates()!
            let des = item.itemDescription?.descriptionElements[descriptorNode!.object! as Descriptor]
            var numberOfDescriptionStates = des?.selectedStates.count
            
            for state in innapStates! {
                if des!.selectedStates.contains(where: {$0 === state}) {
                    numberOfDescriptionStates = numberOfDescriptionStates! - 1
                }
            }
            if numberOfDescriptionStates == 0 {
                return true
            }
            return isInnaplicable(item: item, descriptorNode: descriptorNode?.getParentNode())
        }
        return false
    }
    
    static func calculateCommonPercentage(_ min1: Double, max1: Double, min2: Double, max2: Double) -> Double {
        var minLowerTmp: Double;
        var maxUpperTmp: Double;
        var minUpperTmp: Double;
        var maxLowerTmp: Double;
        var res: Double;
        
        if (min1 <= min2) {
            minLowerTmp = min1;
            minUpperTmp = min2;
        } else {
            minLowerTmp = min2;
            minUpperTmp = min1;
        }
        
        if (max1 >= max2) {
            maxUpperTmp = max1;
            maxLowerTmp = max2;
        } else {
            maxUpperTmp = max2;
            maxLowerTmp = max1;
        }
        
        res = (maxLowerTmp - minUpperTmp) / (maxUpperTmp - minLowerTmp);
        
        if (res < 0) {
            res = 0;
        }
        return res;
    }
    
    public enum ScoreMethod {
        case xper
        case sokalAndMichener
        case jackard
    }
    
}
