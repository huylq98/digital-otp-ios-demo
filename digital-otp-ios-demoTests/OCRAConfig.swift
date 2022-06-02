//
//  OCRAConfig.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation
struct OCRASuite {
    var ocraSuite: String
    var seed: String
    var counter: String
    var question: String
    var password: String
    var sessionInformation: String
    var timeStamp: Int
    var otpExpected: String
}

let seed22 = "fa3ef04873ab5cd8f160a849d0d601df0bd6fffa22e59e6b4cffb89655f3343a"
let seed20 = "3132333435363738393031323334353637383930"
let seed32 = "3132333435363738393031323334353637383930313233343536373839303132"
let seed64 = "31323334353637383930313233343536373839303132333435363738393031323334353637383930313233343536373839303132333435363738393031323334"

let suite1 = "OCRA-1:HOTP-SHA1-6:QN08"
let suite2 = "OCRA-1:HOTP-SHA256-8:C-QN08-PSHA1"
let suite3 = "OCRA-1:HOTP-SHA256-8:QN08-PSHA1"
let suite4 = "OCRA-1:HOTP-SHA512-8:C-QN08"
let suite5 = "OCRA-1:HOTP-SHA512-8:QN08-T30S"
