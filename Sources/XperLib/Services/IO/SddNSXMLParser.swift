//
//  SddNSXMLParser.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 24/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation


open class SddNSXMLParser {
    
    let delegate: SddNSXMLParserDelegate
    
    public init() {
        delegate = SddNSXMLParserDelegate()
    }
    public init(posititionOfDescriptorDependencyTree: Int, positionOfDescriptorGroupTree: Int) {
        delegate = SddNSXMLParserDelegate(positionOfDescriptorGroupTree: positionOfDescriptorGroupTree, posititionOfDescriptorDependencyTree: posititionOfDescriptorDependencyTree)
    }
    
    open func parseDataset(_ sddFileData: Data?) -> Dataset? {
        let nsxmlParser = XMLParser(data: sddFileData!)
        return handleParsing(nsxmlParser)
    }
    
    open func parseDataset(_ sddFileStream: InputStream) -> Dataset? {
        let nsxmlParser = XMLParser(stream: sddFileStream)
        return handleParsing(nsxmlParser)
    }
    
    fileprivate func handleParsing(_ nsxmlParser: XMLParser) -> Dataset? {
        nsxmlParser.delegate = delegate
        if nsxmlParser.parse() {
            return delegate.dataset
        }
        else {
            return nil
        }
    }
}
