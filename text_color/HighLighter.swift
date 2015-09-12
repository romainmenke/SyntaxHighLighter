//
//  Highlighter.swift
//  text_color
//
//  Created by Romain Menke on 03/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation
import UIKit

class SyntaxGroup {
    
    var wordCollection : [String] // it will search for these words
    var type : String // purely a reference
    var color : UIColor // the words will get this color
    
    init(wordCollection_I : [String], type_I : String, color_I: UIColor) {
        
        wordCollection = wordCollection_I
        type = type_I
        color = color_I
        
    }
}

class SyntaxDictionairy {
    
    var collections : [SyntaxGroup] = [] // just an array
    
}

class SyntaxRange {
    
    var range : NSRange // the ranges of found words
    var color : UIColor // the words will get this color
    
    init (color_I : UIColor, range_I : NSRange) {
        color = color_I
        range = range_I
    }
    
}

class HighLighter {
    
    private var ranges : [SyntaxRange] = [] // array of ranges and colors
    private var running : Bool = false // prevent duplicate execution
    
    var highlightedString : NSMutableAttributedString = NSMutableAttributedString() // the resulting string
    var syntaxDictionairy : SyntaxDictionairy // the collection of words and colors
    
    init (syntaxDictionairy_I : SyntaxDictionairy) {
        
        syntaxDictionairy = syntaxDictionairy_I
        
    }
    
    func run(optionalString : String?, completion: (finished: Bool) -> Void) {
        // escape early when it is already running
        if running == true {
            print("double action")
            return
        }
        // string is empty
        guard let string = optionalString where string != "" else {
            print("empty string")
            return
        }
        
        running = true // now we are running
        
        // move to background qeue to prevent UI lock up with a big syntaxDictionairy.
        let qualityOfServiceClass = QOS_CLASS_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue) { () -> Void in
            
            self.ranges = []
            self.highlightedString = NSMutableAttributedString()
            var baseString = NSMutableString()
        
            self.highlightedString = NSMutableAttributedString(string: string)
            
            // go over the entire syntaxDictionairy
            for i in 0..<self.syntaxDictionairy.collections.count {
                
                for iB in 0..<self.syntaxDictionairy.collections[i].wordCollection.count {
                    
                    let currentWordToCheck = self.syntaxDictionairy.collections[i].wordCollection[iB]
                    baseString = NSMutableString(string: string) // reset the baseString for each word, else it will have trouble will words that contain other words.
                    
                    while baseString.containsString(self.syntaxDictionairy.collections[i].wordCollection[iB]) {
                        
                        let nsRange = (baseString as NSString).rangeOfString(currentWordToCheck)
                        let newSyntaxRange = SyntaxRange(color_I: self.syntaxDictionairy.collections[i].color, range_I: nsRange)
                        self.ranges.append(newSyntaxRange)
                        
                        var replaceString = ""
                        for _ in 0..<nsRange.length {
                            replaceString += "§" // secret unallowed character
                        }
                        baseString.replaceCharactersInRange(nsRange, withString: replaceString)
                    }
                }
            }
            
            // use the saved ranged to color the full string step by step.
            for i in 0..<self.ranges.count {
                
                self.highlightedString.addAttribute(NSForegroundColorAttributeName, value: self.ranges[i].color, range: self.ranges[i].range)
                
            }
            
            
            dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                
                // alert view that the highlighting is done.
                self.running = false
                completion(finished: true)
            }
        }
    }
}