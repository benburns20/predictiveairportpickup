//
//  FlightWrapper.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/5/22.
//

import Foundation

class FlightWrapper: ObservableObject {
    
    init(flight: Flight?, pickUpTime: Date?) {
        self.flight = flight
        self.pickUpTime = pickUpTime
    }
    
    @Published var flight: Flight?
    @Published var pickUpTime: Date?
    
}
