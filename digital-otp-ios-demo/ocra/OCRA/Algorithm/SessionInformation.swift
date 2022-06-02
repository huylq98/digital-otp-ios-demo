//
//  SessionInformation.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

protocol SessionInfomationType {
    var sessionInformationLength: Int { get set }

    func getHex(raw: String) -> String
}

struct SessionInfomation064: SessionInfomationType {
    static let identifier: String = "s064"
    var sessionInformationLength: Int = 64

    func getHex(raw: String) -> String {
        var sessionInformation = raw
        while sessionInformation.count < 128 {
            sessionInformation = "0" + sessionInformation
        }

        return sessionInformation
    }
}

struct SessionInfomation128: SessionInfomationType {
    static let identifier: String = "s128"
    var sessionInformationLength: Int = 128

    func getHex(raw: String) -> String {
        var sessionInformation = raw
        while sessionInformation.count < 256 {
            sessionInformation = "0" + sessionInformation
        }

        return sessionInformation
    }
}

struct SessionInfomation256: SessionInfomationType {
    static let identifier: String = "s256"
    var sessionInformationLength: Int = 256

    func getHex(raw: String) -> String {
        var sessionInformation = raw
        while sessionInformation.count < 512 {
            sessionInformation = "0" + sessionInformation
        }

        return sessionInformation
    }
}

struct SessionInfomation512: SessionInfomationType {
    static let identifier: String = "s512"
    var sessionInformationLength: Int = 512

    func getHex(raw: String) -> String {
        var sessionInformation = raw
        while sessionInformation.count < 1024 {
            sessionInformation = "0" + sessionInformation
        }

        return sessionInformation
    }
}
