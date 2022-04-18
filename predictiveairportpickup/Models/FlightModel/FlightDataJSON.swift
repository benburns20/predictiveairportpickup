//
//  FlightDataJSON.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/6/22.
//

import Foundation

struct FlightDataJSON: Decodable {
    var pagination: PaginationJSON
    var data: [DataJSON]
}

struct PaginationJSON: Codable {
    var limit: Int?
    var offset: Int?
    var count: Int?
    var total: Int?
}

struct DataJSON: Codable, Identifiable {
    let id = UUID()
    
    var flight_date: String?
    var flight_status: String?
    var departure: DepartureJSON?
    var arrival: ArrivalJSON?
    var airline: AirlineJSON?
    var flight: FlightJSON?
    var aircraft: AircraftJSON?
    var live: LiveJSON?
}

struct DepartureJSON: Codable {
    var airport: String?
    var timezone: String?
    var iata: String?
    var icao: String?
    var terminal: String?
    var gate: String?
    var delay: Int?
    var scheduled: String?
    var estimated: String?
    var actual: String?
    var estimated_runway: String?
    var actual_runway: String?
}

struct ArrivalJSON: Codable {
    var airport: String?
    var timezone: String?
    var iata: String?
    var icao: String?
    var terminal: String?
    var gate: String?
    var baggage: String?
    var delay: Int?
    var scheduled: String?
    var estimated: String?
    var actual: String?
    var estimated_runway: String?
    var actual_runway: String?
}

struct AirlineJSON: Codable {
    var name: String?
    var iata: String?
    var icao: String?
}

struct FlightJSON: Codable {
    var number: String?
    var iata: String?
    var icao: String?
    var codeshared: CodesharedJSON?
}

struct CodesharedJSON: Codable {
    var airline_iata: String?
    var airline_icao: String?
    var airline_name: String?
    var flight_iata: String?
    var flight_icao: String?
    var flight_number: String?
}

struct AircraftJSON: Codable {
    var registration: String?
    var iata: String?
    var icao: String?
    var icao24: String?
}

struct LiveJSON: Codable {
    var updated: String?
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var direction: Double?
    var speed_horizontal: Double?
    var speed_vertical: Double?
    var is_ground: Bool?
}
