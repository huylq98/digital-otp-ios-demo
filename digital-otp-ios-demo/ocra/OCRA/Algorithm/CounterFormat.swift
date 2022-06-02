//
//  CounterFormat.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

struct CounterFormat {
    static let symbol: Character = "c"

    var counterLength: Int = 0

    init() {
        counterLength = 8
    }

    func getHex(raw: String) -> String {
        var counter = raw
        while counter.count < 16 {
            counter = "0" + counter
        }
        return counter
    }
}
