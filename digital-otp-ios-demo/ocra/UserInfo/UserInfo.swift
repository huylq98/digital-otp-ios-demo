//
//  UserInfo.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 25/05/2022.
//

import Foundation

public class UserInfo: Codable {
    var msisdn: String
    var password: String?
    var privateKey: String?
    var publicKey: String?
    var serverPublicKey: String?
    var status: Bool = true
    var syncTime: Int = 0

    public init(userId: String) {
        msisdn = userId
    }

    public func storedIdentifier() -> String {
        return msisdn
    }
}
