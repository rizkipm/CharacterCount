//
//  TextFieldWithCharacter.swift
//  CharacterCount
//
//  Created by Rizki Syaputra on 11/7/17.
//  Copyright © 2017 Rizki Syaputra. All rights reserved.
//

import UIKit

protocol TextFieldWithCharacterCountDelegate: class {
    //beberpa method textfield delegate yang akan di gunakan
    func didEndEditing()
    func didBeginEditing()
    
    //method lain yang digunakan
    func didReachCharacterLimit(_ reach : Bool)

}

@IBDesignable class TextFieldWithCharacterCount : UITextField {
    
    //deklarasi fileprivate countLabel
    fileprivate let countLabel = UILabel()
    
    //deklarasi variable drhDelegate sebagai object dari TextFieldWithCharacterDelegate
    weak var drhDelegate: TextFieldWithCharacterCountDelegate?
    
    //deklarasi variable lengthlimit
    @IBInspectable var lengthLimit : Int = 0
    //deklarasi variable countLabelColor
    @IBInspectable var countLabelColor : UIColor = UIColor.black
    
    //deklarasi variable costumDelegate
    weak var costumDelegate : UITextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //apabila lengthlimit > 0
        if lengthLimit > 0 {
            //memanggil method setCountLabel
            setCountLabel()
        }
        
        delegate = self as? UITextFieldDelegate
    }
    
    //membuat method setCountLabel
    fileprivate func setCountLabel(){
        rightViewMode = .always
        //mengatur size font
        countLabel.font = font?.withSize(10)
        countLabel.textColor = countLabelColor
        //mengatur posisi text d kiri
        countLabel.textAlignment = .left
        rightView = countLabel
        //memanggil method initialCounterValue yang dibawah
        countLabel.text = initialCounterValue(text)
        //mengecek apakah text sama dengan text
        if let text = text {
            //kondisi apabila sama maka ia akan mengitung text dengan menggunakan format utf16
            countLabel.text = "\(text.utf16.count)/\(lengthLimit)"
            
        }else{
            //kondisi ketika tidak sama maka akan muncul 0
            countLabel.text = "0\(lengthLimit)"
        }
    }
    
    //membuat method baru initialCounterValue
    fileprivate func initialCounterValue(_ text: String?) -> String {
        
        //mengecek apakah text = text
        if let text = text {
            //kondisi ketika sama maka akan menghitung jumlah text
            return "\(text.utf16.count)/\(lengthLimit)"
        }else{
            //apabila tidak sama akan mengembalikan nilai 0
            return "0/\(lengthLimit)"
        }
        
    }
    
    override func  rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        //mengecek apakah nilai nya lebih dari 0
        if lengthLimit > 0 {
            //kondisi ketika nilai limit besar dari 0
            //mengembalikan nilai dengan nilai x , y dan width height = 30
             return CGRect(x: frame.width - 35 , y: 0, width: 30, height: 30)
        }
        return CGRect()
    }
}

//tambahkan extension

extension TextFieldWithCharacterCount: UITextFieldDelegate {
    
    //menambahkan function shouldchangecharacters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //deklarasi nilai text
        guard let text = textField.text , lengthLimit != 0 else { return true }
        
        //deklarasi newLength
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        //mengecek apakah newLength <= lengthLimit
        if newLength <= lengthLimit {
            //kondisi ketika newLength <= length limit
            //countlabel menampilkan text newlength
            countLabel.text = "\(newLength)/\(lengthLimit)"
            drhDelegate?.didReachCharacterLimit(false)
            
        }else{
            //kondisi ketika tidak sama
            drhDelegate?.didReachCharacterLimit(true)
            
            //menambahkan animasi
            UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (finish) in UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform.identity
            })})
        }
        //menambahkan return
        return newLength <= lengthLimit
        
    }
    
    //menambahkan method textFieldEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        drhDelegate?.didEndEditing()
    }
    //menambahkan method didBeginingEditing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        drhDelegate?.didBeginEditing()
    }
    
}
