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
     
     - Returns:Item fromo Keychain
     */
    
    func getKey(service: String, account: String) -> Data? {
        // Create query dict which can be passed  on to secItemAdd function
        let query = [
            kSecClass:  kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecMatchLimit:  kSecMatchLimitOne, // Alternatively use an integer or kSecMatchLimitAll. using All will return an array
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
        
        // result will capture the data in Keychain
        var result: CFTypeRef?
        
        // calling keychain item add function and pass query dict as input
        let status = SecItemCopyMatching(query, &result)
        
        guard status != errSecItemNotFound else {
            debugPrint("Key not found: Error code - \(status)")
            return nil
        }
        guard status == errSecSuccess else {
            debugPrint("Failed to retrieve Keychain: Error Code - \(status) ")
            return nil
        }
                
        guard let existingItem = result as? [String: Any],
              let rawKey = existingItem[kSecValueData as String] as? Data,
              let account  = existingItem[kSecAttrAccount as String] as? String,
              let service = existingItem[kSecAttrService as String] as? String
        else{
            debugPrint("Failed to get data from Keychain")
            return nil
        }
        print("Found key for Account: \(account) and Service: \(service)")
        return rawKey
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

extension KeychainHelper{
    /**
     Save input key of Codable object tye into keychain.
     
     Saves the input data in Keychain as a  generic password. 'service' and 'account' attributes are used as primary key to save the data.
     
     - Parameters:
         - account: String value to be used as Primary Key
         - service: String value to be used as Primary Key
     
     - Returns: Status of Save item action
     */
    func saveKey<T: Codable>(_ data: T, service: String, account: String) -> Void {
        
        // first convert input data to JSON encoding
        do{
            let encodedData = try JSONEncoder().encode(data)
            saveKey(encodedData, service: service, account: account)
        } catch{
            debugPrint("Error while JSON encodig: \(error)")
        }
    }
    
    func getKey<T: Codable>(service: String, account: String, type: T.Type) -> T? {
        do{
            guard let encodedKey = getKey(service: service, account: account) else{
                debugPrint("unable to find key")
                return nil
            }
            let decodedKey = try JSONDecoder().decode(type, from: encodedKey)
            return decodedKey
        }catch{
            debugPrint("Unable to decode Key using Decoder: \(error)")
            return nil
        }
    }
}
