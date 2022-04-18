//
//  FlightInfoView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/12/22.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.size.width - 70

struct FlightInfoView: View {
    
    @ObservedObject var flight: Flight
    
    var body: some View {
        VStack {
            HStack {
                //flight code and status
                //DL1234
                Text(flight.flight_iata)
                    .font(.system(size: 25, weight: .regular))
                    .lineSpacing(3)
                
                Spacer()
                
                //Arrived
                FlightStatus(flight: flight)
            }
            
            HStack {
                //dep to arr
                //DEN
                Text(flight.dep_iata)
                    .font(.system(size: 50, weight: .bold))
                    .lineSpacing(3)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Image("Forward Arrow (Big)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipped()
                
                Spacer()
                
                //ATL
                Text(flight.arr_iata)
                    .font(.system(size: 50, weight: .bold))
                    .lineSpacing(3)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                //info
                
                DepartureInfo(flight: flight)
                    .frame(width: screenWidth / 2, alignment: .leading)
                
                Spacer()
                
                ArrivalInfo(flight: flight)
                    .frame(width: screenWidth / 2, alignment: .topTrailing)
            }
            
            //Pick-Up Terminal:
            Text("Pick-Up Terminal:")
                .font(.system(size: 30, weight: .regular))
                .multilineTextAlignment(.center)
                .padding([.top])
            
            if flight.terminal == "S" {
                //South
                Text("South").font(.system(size: 45, weight: .bold)).multilineTextAlignment(.center)
            } else {
                //South
                Text("North").font(.system(size: 45, weight: .bold)).multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

struct FlightStatus: View {
    @ObservedObject var flight: Flight
    
    var body: some View {
        if flight.arr_actual != "" {
            Text("Arrived")
                .font(.system(size: 25, weight: .regular))
                .lineSpacing(3)
                .multilineTextAlignment(.trailing)
        } else if flight.dep_delay != 0 {
            Text("Delayed")
                .font(.system(size: 25, weight: .regular))
                .lineSpacing(3)
                .multilineTextAlignment(.trailing)
        } else if flight.dep_actual != "" {
            Text("En Route")
                .font(.system(size: 25, weight: .regular))
                .lineSpacing(3)
                .multilineTextAlignment(.trailing)
        } else {
            Text("On Time")
                .font(.system(size: 25, weight: .regular))
                .lineSpacing(3)
                .multilineTextAlignment(.trailing)
        }
    }
}

let infoFontSize = 20.0

struct DepartureInfo: View {
    @ObservedObject var flight: Flight
    
    var body: some View {
        
        if (flight.dep_actual != nil) && (flight.dep_actual != "") {
            
            if (flight.dep_delay != nil) && (flight.dep_delay != 0) {
        
                Text("Dep: ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.dep_actual ?? "Error") (\(flight.dep_delay ?? 0) min delay)")
                    .font(.system(size: infoFontSize, weight: .regular)).foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                
            } else {
                
                Text("Dep: ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.dep_actual ?? "error")")
                    .font(.system(size: infoFontSize, weight: .regular))
                
            }
            
        } else {
            
            if (flight.dep_delay != nil) && (flight.dep_delay != 0) {
                
                Text("Dep (Est.): ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.dep_estimated) (\(flight.dep_delay ?? 0) min delay)")
                    .font(.system(size: infoFontSize, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                
            } else {
                
                Text("Dep (Est.): ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.dep_estimated)")
                    .font(.system(size: infoFontSize, weight: .regular))
                
            }
        }
    }
}

struct ArrivalInfo: View {
    @ObservedObject var flight: Flight
    
    var body: some View {
        //Arr (Est.): 8:09 PM (120 m...
        if (flight.arr_actual != nil) && (flight.arr_actual != "") {
            
            if (flight.arr_delay != nil) && (flight.arr_delay != 0) {
            
                Text("Arr: ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.arr_actual ?? "Error")")
                    .font(.system(size: infoFontSize, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                
            } else {
                
                Text("Arr: ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.arr_actual ?? "Error")")
                    .font(.system(size: infoFontSize, weight: .regular))
                
            }
            
        } else {
            
            if (flight.arr_delay != nil) && (flight.arr_delay != 0) {
            
                Text("Arr (Est.): ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.arr_estimated)")
                    .font(.system(size: infoFontSize, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                
            } else {
                
                Text("Arr (Est.): ").font(.system(size: infoFontSize, weight: .regular)) + Text("\(flight.arr_estimated)")
                    .font(.system(size: infoFontSize, weight: .regular))
                
            }
            
        }
    }
}

let example_flight2 = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "3:42", arr_estimated: "3:57", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

struct FlightInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        FlightInfoView(flight: example_flight2)
    }
}
