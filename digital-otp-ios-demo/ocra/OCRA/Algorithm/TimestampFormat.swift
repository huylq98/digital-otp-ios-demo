//
//  TimestampFormat.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

struct TimestampFormat {
    static let identifier: Character = "T"
    enum Unit: String {
        case Seconds = "S"
        case Minutes = "M"
        case Hours = "H"

        var time: Int {
            switch self {
            case .Seconds:
                return 1000
            case .Minutes:
                return 60*1000
            case .Hours:
                return 60*60*1000
            }
        }
    }

    var timeStampLength: Int = 8
    var unit: Unit?
    var multiple: Int?

    init(_ timestamp: String) {
        var temp = timestamp
        temp.removeFirst()
        let unitCharater = temp.removeLast()
        self.unit = Unit(rawValue: String(unitCharater).uppercased())
        self.multiple = Int(temp)
    }

    func getHex(raw: Int) -> String {
        guard let unit = unit, let multiple = multiple else { return "" }
        var timeStamp = String(raw / (multiple*unit.time), radix: 16)
        while timeStamp.count < 16 {
            timeStamp = "0" + timeStamp
        }
        return timeStamp
    }
}
