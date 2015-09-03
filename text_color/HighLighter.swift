//
//  Highlighter.swift
//  text_color
//
//  Created by Romain Menke on 03/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation
import UIKit

// text hightlighter

class SyntaxGroup {
    
    var wordCollection : [String]
    var type : String
    var color : UIColor
    
    init(wordCollection_I : [String], type_I : String, color_I: UIColor) {
        
        wordCollection = wordCollection_I
        type = type_I
        color = color_I
        
    }
}

class SyntaxDictionairy {
    
    var collections : [SyntaxGroup] = []
    
}

class SyntaxRange {
    
    var range : NSRange
    var color : UIColor
    
    init (color_I : UIColor, range_I : NSRange) {
        color = color_I
        range = range_I
    }
    
}

class HighLighter {
    
    private var ranges : [SyntaxRange] = []
    var highlightedString : NSMutableAttributedString = NSMutableAttributedString()
    var syntaxDictionairy : SyntaxDictionairy
    
    init (syntaxDictionairy_I : SyntaxDictionairy) {
        
        syntaxDictionairy = syntaxDictionairy_I
        
    }
    
    func run(string : String?, completion: (finished: Bool) -> Void) {
        
        ranges = []
        highlightedString = NSMutableAttributedString()
        var baseString = NSMutableString()
        
        let qualityOfServiceClass = QOS_CLASS_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue) { () -> Void in
        
            if string != nil && string != "" {
            
                self.highlightedString = NSMutableAttributedString(string: string!)
                
                for i in 0..<self.syntaxDictionairy.collections.count {
                    
                    for iB in 0..<self.syntaxDictionairy.collections[i].wordCollection.count {
                        
                        let currentWordToCheck = self.syntaxDictionairy.collections[i].wordCollection[iB]
                        baseString = NSMutableString(string: string!)
                        
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
                for i in 0..<self.ranges.count {
                    
                    self.highlightedString.addAttribute(NSForegroundColorAttributeName, value: self.ranges[i].color, range: self.ranges[i].range)
                    
                }
            }
            
            dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                
                completion(finished: true)
            }
            
        }
    }
    
}