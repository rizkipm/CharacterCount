//
//  ViewController.swift
//  CharacterCount
//
//  Created by Rizki Syaputra on 11/7/17.
//  Copyright © 2017 Rizki Syaputra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtText: TextFieldWithCharacterCount?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //implement method
        txtText?.drhDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: TextFieldWithCharacterCountDelegate {
    func didEndEditing() {
        print("end editing")
    }
    
    func didBeginEditing() {
        print("begin editing")
    }
    
    func didReachCharacterLimit(_ reach: Bool) {
        if reach {
            print("limit reach")
        }else{
            print("have more chars to go")
        }
    }
    
    
}
