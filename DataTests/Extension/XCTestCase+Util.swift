//
//  XCTestCase+Util.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import Foundation
import XCTest

extension XCTestCase {

    func checkMemoryLeak(for instance: AnyObject,
                         file: StaticString = #file,
                         line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }    
}
