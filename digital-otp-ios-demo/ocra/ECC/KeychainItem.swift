//
//  KeychainItem.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

public struct KeychainItem {
    // MARK: Types

    enum KeychainError: Error {
        case noUserData
        case unexpectedUserData
        case unexpectedItemData
        case unhandledError
    }

    // MARK: Properties

    let service: String = "TODO_REPLACE_SERVICEID" // TODO:

    public func saveData(of user: UserInfo) throws {
        let userData = CodeableUtil.shared.encode(object: user)
        do {
            // Check for an existing user's data in the keychain.
            try _ = readData(by: user.storedIdentifier())

            // Update the existing user with the new data.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = userData as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service, account: user.storedIdentifier())
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noUserData {
            /*
             No user's data(with userId) was found in the keychain. Create a dictionary to save as a new keychain item.
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: user.storedIdentifier())
            newItem[kSecValueData as String] = userData as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }

    public func readData(by userId: String) throws -> UserInfo {
        /*
         Build a query to find the item that matches the service, account and access group(nil).
         */
        var query = KeychainItem.keychainQuery(withService: service, account: userId)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noUserData }
        guard status == noErr else { throw KeychainError.unhandledError }

        // Parse the user's data string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
              let userInfoData = existingItem[kSecValueData as String] as? Data,
              let userInfo = CodeableUtil.shared.decode(json: userInfoData, as: UserInfo.self)
        else {
            throw KeychainError.unexpectedUserData
        }

        return userInfo
    }

    func deleteData(by userId: String) throws {
        // Delete the existing user's data from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: userId)
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }

    // MARK: Convenience

    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
}
