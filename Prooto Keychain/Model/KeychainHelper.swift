//
//  KeychainHelper.swift
//  Prooto Keychain
//
//  Created by Santosh Krishnamurthy on 2/8/23.
//

import Foundation

final class KeychainHelper{
    static let standard = KeychainHelper()
    private init() {}
    
    /**
     function saves the input data in Keychain as a  generic password. 'service' and 'account' attributes are used as primary key to save the data.
    */
    func saveGenericPassword(_ data: Data, service: String, account: String) -> Void {
        // Create query dict which can be passed  on to secItemAdd function
        let query = [
            kSecClass:  kSecClassGenericPassword,
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: service
        ] as CFDictionary
        
        // calling keychain item add function and pass query dict as input
        let status = SecItemAdd(query, nil)
        
        // check if error occured and print error code
        if status != errSecSuccess{
            print("Error saving data to Keychain: \(status)")
        }
        
        if status == errSecDuplicateItem{
            print("Keychain already contains data. Attempting to update data")
            // Create query dict which can be passed  on to secItemAdd function
            let updateQuery = [
                kSecClass:  kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: service
            ] as CFDictionary
            
            let dataToUpdate = [kSecValueData: data] as CFDictionary
            
            // calling keychain item add function and pass query dict as input
            let status = SecItemUpdate(updateQuery, dataToUpdate)
            
            // check if error occured and print error code
            if status != errSecSuccess{
                print("Error updating data to Keychain: \(status)")
            } else{
                print("Keychain update successful")
            }
            
        }
        
    }
}
