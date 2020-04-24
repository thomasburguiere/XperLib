//
//  SddParsingPerformanceTests.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 25/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation
import XCTest
@testable import XperLib


class SddParsingPerformanceTests: XCTestCase {
    
    func skipped_testPerformancesGenetta(){
        self.measure{
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))
            
            let nsxmlParser = XMLParser(data: fileData!)
            let delegate = SddNSXMLParserDelegate()
            nsxmlParser.delegate = delegate
            nsxmlParser.parse()
        }
    }
    func skipped_testPerformancesGenettaGCD(){
        self.measure{
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))
            
            let nsxmlParser = XMLParser(data: fileData!)
            let delegate = SddNSXMLParserDelegate()
            nsxmlParser.delegate = delegate
            
            let rssQueue = DispatchQueue(label: "com.example.parser", attributes: []);
            rssQueue.sync(execute: {
                nsxmlParser.parse()
            })
            
        }
    }
    
    func skipped_testPerformancesGenettaStream(){
        self.measure{
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))
            let stream = InputStream(data: fileData!)
            let nsxmlParser = XMLParser(stream: stream)
            let delegate = SddNSXMLParserDelegate()
            nsxmlParser.delegate = delegate
            nsxmlParser.parse()
        }
    }
    
    func skipped_testPerformancesGenettaStreamGCD(){
        self.measure{
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))
            let stream = InputStream(data: fileData!)
            let nsxmlParser = XMLParser(stream: stream)
            let delegate = SddNSXMLParserDelegate()
            nsxmlParser.delegate = delegate
            let rssQueue = DispatchQueue(label: "com.example.parser2", attributes: []);
            rssQueue.sync(execute: {
                nsxmlParser.parse()
            })
        }
    }
    
//    func testPerformancesCichorieae(){
//        self.measureBlock{let fileData = NSData(contentsOfFile: self.getSddTestFileLocation("cichorieae")!)
//            let stream = NSInputStream(data: fileData!)
//            let nsxmlParser = NSXMLParser(stream: stream)
//            let delegate = SddNSXMLParserDelegate()
//            nsxmlParser.delegate = delegate
//            let rssQueue = dispatch_queue_create("com.example.parser.cichorieae", nil);
//            dispatch_sync(rssQueue, {
//                nsxmlParser.parse()
//            })
//
//        }
//    }
}
