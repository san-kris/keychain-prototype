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
     Save input key into keychain.
     
     Saves the input data in Keychain as a  generic password. 'service' and 'account' attributes are used as primary key to save the data.
     
     - Parameters:
     - account: String value to be used as Primary Key
     - service: String value to be used as Primary Key
     
     - Returns: Status of Save item action
     */
    func saveKey(_ data: Data, service: String, account: String) -> Void {
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
    
    /**
     Read key from keychain.
     
     Query Keychain based on Account and Service to find the key. 'service' and 'account' attributes are used as primary key to read the data.
     
     - Parameters:
     - account: String value to be used as Primary Key
     - service: String value to be used as Primary Key
     
     - Returns: Status of Save item action
     */
    
    func getKey(service: String, account: String) -> Data? {
        // Create query dict which can be passed  on to secItemAdd function
        let query = [
            kSecClass:  kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true
        ] as CFDictionary
        
        // result will capture the data in Keychain
        var result: AnyObject?
        
        // calling keychain item add function and pass query dict as input
        let status = SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    /**
     Read key from keychain.
     
     Query Keychain based on Account and Service to find the key. 'service' and 'account' attributes are used as primary key to read the data.
     
     - Parameters:
     - account: String value to be used as Primary Key
     - service: String value to be used as Primary Key
     
     - Returns: Status of Save item action
     */
    
    func deleteKey(service: String, account: String) -> Void {
        // Create query dict which can be passed  on to secItemAdd function
        let query = [
            kSecClass:  kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service
        ] as CFDictionary
                
        // calling keychain item add function and pass query dict as input
        let status = SecItemDelete(query)
        
        debugPrint("Delete Action response \(status)")
        
    }
}
