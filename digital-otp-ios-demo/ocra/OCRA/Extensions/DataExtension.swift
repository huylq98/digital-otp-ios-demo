//
//  DataExtensions.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation
public extension DataProtocol {
    var data: Data { .init(self) }
    var hexaAsString: String { map { .init(format: "%02x", $0) }.joined() }
}
