//
//  Utils.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 25/05/2022.
//

import Foundation

public struct CodeableUtil {
    private init() {}
    static let shared = CodeableUtil()

    func encode<T: Codable>(object: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func decode<T: Decodable>(json: Data, as _: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: json)

            return data
        } catch {
            print("An error occurred while parsing JSON")
        }

        return nil
    }
}
