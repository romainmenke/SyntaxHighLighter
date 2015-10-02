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
    private var ticketMan = TicketMan() // prevent duplicate execution
    
    var stringCompareOptions : NSStringCompareOptions = NSStringCompareOptions.LiteralSearch
    
    var highlightedString : NSMutableAttributedString? // the resulting string
    var syntaxDictionairy : SyntaxDictionairy // the collection of words and colors
    
    init (syntaxDictionairy_I : SyntaxDictionairy) {
        
        syntaxDictionairy = syntaxDictionairy_I
        
    }
    
    func run(string string_I: String?, completion: (highlightedString: NSAttributedString) -> Void) {
        guard let unwrString_I = string_I where unwrString_I != "" else {
            return
        }
        
        let ticket = self.ticketMan.ticket
        
        ticketMan.backgroundOperation({ () -> () in
            
            self.clean()
            
            self.highlight(string: unwrString_I, ticket: ticket)
            
            }) { () -> () in
                
                self.ticketMan.ripTicket(ticket: ticket)
                
                guard let hlString = self.highlightedString else {
                    return
                }
                
                completion(highlightedString: hlString)
                
        }
    }
    
    private func clean() {
        
        self.ranges = []
        self.highlightedString = NSMutableAttributedString()
        
    }
    
    private func highlight(string string_I : String, ticket ticket_I: Int ) {
        
        self.highlightedString = NSMutableAttributedString(string: string_I)
        
        // go over the entire syntaxDictionairy
        self.syntaxDictionairy.collections.forEach { sGroup in
            
            // validate ticket each pass, put these inside expensive loops
            if self.ticketMan.validateTicket(ticket: ticket_I) == false {
                self.highlightedString = nil
                return
            }
            syntaxGroupSearch(syntaxGroup: sGroup, string: string_I)
        }
        
        self.addAttributes(ticket: ticket_I)
        
    }
    
    private func syntaxGroupSearch(syntaxGroup syntaxGroup_I:SyntaxGroup, string string_I:String) {
        
        syntaxGroup_I.wordCollection.forEach { word in
            
            let baseString = NSMutableString(string: string_I)
            
            while baseString.containsString(word) {
                
                let nsRange = (baseString as NSString).rangeOfString(word, options: stringCompareOptions)
                let newSyntaxRange = SyntaxRange(color_I: syntaxGroup_I.color, range_I: nsRange)
                self.ranges.append(newSyntaxRange)
                
                var replaceString = ""
                for _ in 0..<nsRange.length {
                    replaceString += "§" // secret unallowed character
                }
                baseString.replaceCharactersInRange(nsRange, withString: replaceString)
            }
        }
    }
    
    private func addAttributes(ticket ticket_I:Int) {
        
        guard let unwrHighlightedString = self.highlightedString else {
            self.ticketMan.ripTicket(ticket: ticket_I)
            return
        }
        
        ranges.forEach { range in unwrHighlightedString.addAttribute(NSForegroundColorAttributeName, value: range.color, range: range.range) }
        self.highlightedString = unwrHighlightedString
    }
}