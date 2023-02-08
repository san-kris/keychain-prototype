//
//  ViewController.swift
//  Prooto Keychain
//
//  Created by Santosh Krishnamurthy on 2/8/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataTextfield: UITextField!
    
    let account = "san.b350"
    let service = "gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func savePressed(_ sender: UIButton) {
        guard let data = dataTextfield.text else{
            print("Enter data in text field")
            return
        }
        print("Data entered: \(data)")
        
        // convert string data to raw data
        guard let rawData = data.data(using: String.Encoding.utf8) else {
            print("dailed to convert string data to Data object")
            return
        }
        
        let keychainHelper = KeychainHelper.standard
        
        keychainHelper.saveGenericPassword(rawData, service: service, account: account)
    }
    
    @IBAction func readPressed(_ sender: UIButton) {
        print(dataTextfield.text!)
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        print(dataTextfield.text!)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        print(dataTextfield.text!)
    }
    
}

