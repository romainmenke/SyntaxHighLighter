//
//  ViewController.swift
//  text_color
//
//  Created by Romain Menke on 02/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var myTextfield: UITextField!
    @IBOutlet weak var myTextView: UITextView!
    
    var syntaxHighLighter : HighLighter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHighLighter()
        myTextView.delegate = self
        
    }
    
    func setUpHighLighter() {
        
        // build a dict of words to highlight
        let redColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
        let blueColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        let greenColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        
        let redGroup = SyntaxGroup(wordCollection_I: ["red","bordeaux"], type_I: "Color", color_I: redColor)
        let blueGroup = SyntaxGroup(wordCollection_I: ["coralblue","blue","skyblue","azur"], type_I: "Color", color_I: blueColor)
        let greenGroup = SyntaxGroup(wordCollection_I: ["green"], type_I: "Color", color_I: greenColor)
        
        let dictionairy : SyntaxDictionairy = SyntaxDictionairy()
        dictionairy.collections.append(blueGroup)
        dictionairy.collections.append(greenGroup)
        dictionairy.collections.append(redGroup)
        
        syntaxHighLighter = HighLighter(syntaxDictionairy_I: dictionairy)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let currentRange = myTextView.selectedRange
        
        syntaxHighLighter.run(myTextView.text) { (finished) -> Void in
            
            // check highlightedString for nil
            guard let unwrHighlightedString = self.syntaxHighLighter.highlightedString else {
                return
            }
            
            // if the highlighter was slower than typing, ABORT
            guard let textInUITextView = self.myTextfield.attributedText where textInUITextView.length == unwrHighlightedString.length else {
                return
            }
            
            self.myTextView.attributedText = self.syntaxHighLighter.highlightedString
            self.myTextView.selectedRange = currentRange
        }
        
    }
    
    // in case of weird cursor movements (only one case)
//    func textViewDidChangeSelection(textView: UITextView) {
//
//        print("selection changed: \(myTextView.selectedTextRange!)")
//        
//    }

    @IBAction func editingChanged(sender: UITextField) {
        
        let currentRange = myTextfield.selectedTextRange
        
        syntaxHighLighter.run(myTextfield.text) { (finished) -> Void in
            
            // check highlightedString for nil
            guard let unwrHighlightedString = self.syntaxHighLighter.highlightedString else {
                return
            }
            
            // if the highlighter was slower than typing, ABORT
            guard let textInUITextField = self.myTextfield.attributedText where textInUITextField.length == unwrHighlightedString.length else {
                return
            }
            
            self.myTextfield.attributedText = self.syntaxHighLighter.highlightedString
            self.myTextfield.selectedTextRange = currentRange
        }
    }
}

