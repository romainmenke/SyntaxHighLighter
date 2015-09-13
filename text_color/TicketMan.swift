//
//  TicketMan.swift
//  text_color
//
//  Created by Romain Menke on 13/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation


class TicketMan {
    
    private var ticketStack : Int = 0
    private var ticketCounter : Int = 0
    
    var ticket : Int {
        get {
            ticketStack += 1
            ticketCounter += 1
            return ticketCounter
        }
    }
    
    func ripTicket(ticket : Int) {
        
        ticketStack -= 1
        
        if ticketStack == 0 {
            ticketCounter = 0
        }
    }
    
    func validateTicket(ticket: Int) -> Bool {
        
        if ticket == ticketCounter {
            print(ticket)
            return true
        } else {
            ticketStack -= 1
            return false
        }
    }
}