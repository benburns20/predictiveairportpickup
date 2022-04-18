//
//  MainView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/31/22.
//

import SwiftUI

struct MainView: View {
    static var tracked_flight = FlightWrapper(flight: nil, pickUpTime: nil)
    static var pickUpTime: Date? = nil
    
    var body: some View {
        TabView {
            MainSearchView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Current Flights")
                }
            
            PreviousFlightsView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Previous Flights")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
