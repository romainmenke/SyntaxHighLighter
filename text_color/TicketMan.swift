//
//  TicketMan.swift
//  text_color
//
//  Created by Romain Menke on 13/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation


class TicketMan {
    
    var ticketStack : Int = 0
    var ticketCounter : Int = 0
    
    var ticket : Int {
        get {
            ticketStack += 1
            ticketCounter += 1
            return ticketCounter
        }
    }
}

extension TicketMan {
    
    func ripTicket(ticket ticket_I: Int) {
        
        ticketStack -= 1
        
        if ticketStack == 0 {
            ticketCounter = 0
        }
    }
    
    func validateTicket(ticket ticket_I: Int) -> Bool {
        
        if ticket_I == ticketCounter {
            return true
        } else {
            ripTicket(ticket: ticket_I)
            return false
        }
    }
    
}


extension TicketMan {
    
    func backgroundOperation(operation:()->(),completion:()->()) {
        
        let qualityOfServiceClass = QOS_CLASS_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue) { () -> Void in
            
            operation()
            
            dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                completion()
            }
            
        }
    }
}




