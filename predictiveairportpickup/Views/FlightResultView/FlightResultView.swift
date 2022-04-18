//
//  ResultView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import SwiftUI

struct FlightResultView: View {
    
//    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    @ObservedObject var manager: LocationManager
    @ObservedObject var flight: Flight
    @ObservedObject var airportTimeModel: AirportTimeModel
    @ObservedObject var airportTimeBaggageModel: AirportTimeBaggageModel
    
    @Binding var rootIsActive : Bool
    
    var body: some View {
        VStack {
            FlightInfoView(flight: flight)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: PickUpTimeView(shouldPopToRootView: $rootIsActive, manager: manager, flight: flight, airportTimeModel: airportTimeModel, airportTimeBaggageModel: airportTimeBaggageModel)) {
                Text("Track This Flight?")
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            
            Spacer()
            Spacer()
            
            
    //        Button(action: {
    //            self.presentationMode.wrappedValue.dismiss()
    //        }){
    //            Text("Dismiss")
    //        }
        }
        .offset(y: 30)
    }
}
