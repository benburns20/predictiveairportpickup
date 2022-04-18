//
//  Flights.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/14/22.
//

import Foundation

class Flights: ObservableObject {
    @Published var flights: [Flight]
    
    init(flights_input: [Flight]) {
        self.flights = flights_input
    }
}

let example_flight3 = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "3:42", arr_estimated: "3:57", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

let example_flight4 = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "3:42", arr_estimated: "3:57", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

let example_flight5 = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "5:42 PM", arr_estimated: "5:57 PM", airline: "Delta", flight_number: 1432, flight_iata: "DL1432", arr_estimated_date: "2022-04-16T21:57:00+0000")

let example_flight6 = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "3:42", arr_estimated: "3:57", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

let example_flights_array = Flights(flights_input: [
    example_flight3,
    example_flight4,
    example_flight5,
    example_flight6
])
