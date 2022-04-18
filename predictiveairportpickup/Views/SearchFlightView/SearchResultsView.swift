//
//  SearchResultsView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/14/22.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Binding var rootIsActive: Bool
    
    @ObservedObject var manager: LocationManager
    @ObservedObject var flights: Flights
    @ObservedObject var airportTimeModel: AirportTimeModel
    @ObservedObject var airportTimeBaggageModel: AirportTimeBaggageModel
    
    var body: some View {
        List {
            ForEach(flights.flights) { flight in
                
                ZStack {
                    NavigationLink(destination: FlightResultView(manager: manager, flight: flight, airportTimeModel: airportTimeModel, airportTimeBaggageModel: airportTimeBaggageModel, rootIsActive: $rootIsActive)) {
                        FlightCardView(flight: flight)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
