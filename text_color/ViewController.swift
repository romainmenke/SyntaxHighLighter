//
//  ViewController.swift
//  text_color
//
//  Created by Romain Menke on 02/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextfield: UITextField!
    
    var syntaxHighLighter : HighLighter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHighLighter()
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

    @IBAction func editingChanged(sender: UITextField) {
        
        syntaxHighLighter.run(myTextfield.text) { (finished) -> Void in
            self.myTextfield.attributedText = self.syntaxHighLighter.highlightedString
        }
    }
}

