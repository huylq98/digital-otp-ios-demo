//
//  Register.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import Foundation

struct Register {
    struct Request: Codable {
        init(h: String) {
            self.h = h
        }
        var otp: String = "1111"
        var h: String
        var app_key: String = "54555a72643056335755684c6231704a656d6f775130465257556c4c6231704a656d6f7752454652593052525a30464661465a4d626a4d794d6e42464b7a467663555a4a64564e594e4656475a464a58536e564d555642525246567a4e6a6c484e6a4e61566e4a6c656b68325a6c70515255315864577061647a4d7664455934575452755a3346734f4646475a57643661475a5853306c5261565a744b306f304b3045395051"
        var device_name: String = "android"
    }
    struct Response: Codable {
        var server_key: String
        var server_time: Int64
    }
}
