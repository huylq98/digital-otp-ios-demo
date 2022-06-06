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

    func addDerKeyInfo(rawPublicKey: [UInt8]) -> [UInt8] {
        let DerHdrSubjPubKeyInfo: [UInt8] = [
            /* Ref: RFC 5480 - SubjectPublicKeyInfo's ASN encoded header */
            0x30, 0x59, /* SEQUENCE */
            0x30, 0x13, /* SEQUENCE */
            0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01, /* oid: 1.2.840.10045.2.1   */
            0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07, /* oid: 1.2.840.10045.3.1.7 */
            0x03, 0x42, /* BITSTRING */
            0x00, /* unused number of bits in bitstring, followed by raw public-key bits */
        ]
        let derKeyInfo = DerHdrSubjPubKeyInfo + rawPublicKey
        return derKeyInfo
    }

    func convertSecKeyToDerKeyFormat(key: SecKey) throws -> String {
        var error: Unmanaged<CFError>?
        do {
            if let externalRepresentationOfPublicKey = SecKeyCopyExternalRepresentation(key, &error)
            {
                let derKeyFormat: Data = externalRepresentationOfPublicKey as Data
                let publicKeyByteArray = addDerKeyInfo(rawPublicKey: derKeyFormat.hexaAsString.hexaBytes)
                return Data(publicKeyByteArray).hexaAsString

            } else {
                throw error as! Error
            }
        } catch {
            throw error
        }
    }
}
