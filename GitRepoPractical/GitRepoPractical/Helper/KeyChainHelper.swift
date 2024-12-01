//
//  KeyChainHelper.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import Foundation

struct KeychainHelper {
    static func save(value: String, for key: String) {
        let data = value.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        SecItemDelete(query) // Delete existing item
        SecItemAdd(query, nil)
    }

    static func load(for key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        if SecItemCopyMatching(query, &result) == noErr {
            if let data = result as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

    static func delete(for key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status == errSecSuccess {
            print("Keychain item successfully deleted for key: \(key)")
        } else {
            print("Failed to delete Keychain item for key: \(key), status: \(status)")
        }
    }
}
