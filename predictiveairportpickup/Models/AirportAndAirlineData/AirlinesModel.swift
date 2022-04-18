//
//  AirlinesModel.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/12/22.
//

import Foundation


class AirlinesModel: ObservableObject {
    @Published var searchText = ""
    
    let allAirlines: [String]
    var filteredAirlines: [String] = [String]()
    
    init() {
        self.allAirlines = airlines
        self.filteredAirlines = allAirlines
    }
    
    let airlines: [String] = [
        "Alaska Airlines",
        "American Airlines",
        "Boutique Air",
        "Delta Air Lines",
        "Frontier Airlines",
        "JetBlue Airways",
        "Southwest Airlines",
        "Spirit Airlines",
        "United Airlines",
        "Air Canada",
        "Air France",
        "British Airways",
        "Copa Airlines",
        "KLM Royal Dutch Airways",
        "Korean Air",
        "Lufthansa",
        "Qatar Airways",
        "Turkish Airlines",
        "Virgin Atlantic",
        "Westjet"
    ]
    
    let airlinesMapping: [String: String] = [
        "Alaska Airlines": "AS",
        "American Airlines": "AA",
        "Boutique Air": "4B",
        "Delta Air Lines": "DL",
        "Frontier Airlines": "F9",
        "JetBlue Airways": "B6",
        "Southwest Airlines": "WN",
        "Spirit Airlines": "NK",
        "United Airlines": "UA",
        "Air Canada": "AC",
        "Air France": "AF",
        "British Airways": "BA",
        "Copa Airlines": "CM",
        "KLM Royal Dutch Airways": "KL",
        "Korean Air": "KE",
        "Lufthansa": "LH",
        "Qatar Airways": "QR",
        "Turkish Airlines": "TK",
        "Virgin Atlantic": "VS",
        "Westjet": "WS"
    ]
    
}
