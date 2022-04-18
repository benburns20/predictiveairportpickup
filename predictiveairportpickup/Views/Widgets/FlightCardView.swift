//
//  FlightCardView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/4/22.
//

import SwiftUI

struct FlightCardView: View {
    @ObservedObject var flight: Flight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                //DEN to ATL Dep: 12:34 PM (...
                Text("\(flight.dep_iata) ").font(.system(size: 25, weight: .bold)) + Text("to ").font(.system(size: 25, weight: .regular)) + Text("\(flight.arr_iata)").font(.system(size: 25, weight: .bold))
                
                if (flight.dep_actual != nil) && (flight.dep_actual != "") {
                    
                    if (flight.dep_delay != nil) && (flight.dep_delay != 0) {
                    
                        Text("Dep: ").font(.system(size: 15, weight: .regular)) + Text("\(flight.dep_actual ?? "Error") (\(flight.dep_delay ?? 0) min delay)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                        
                    } else {
                        
                        Text("Dep: ").font(.system(size: 15, weight: .regular)) + Text("\(flight.dep_actual ?? "Error")")
                            .font(.system(size: 15, weight: .regular))
                        
                    }
                    
                } else {
                    
                    if (flight.dep_delay != nil) && (flight.dep_delay != 0) {
                    
                        Text("Dep (Est.): ").font(.system(size: 15, weight: .regular)) + Text("\(flight.dep_estimated) (\(flight.dep_delay ?? 0) min delay)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                        
                    } else {
                        
                        Text("Dep (Est.): ").font(.system(size: 15, weight: .regular)) + Text("\(flight.dep_estimated)")
                            .font(.system(size: 15, weight: .regular))
                        
                    }
                    
                }
                
                if (flight.arr_actual != nil) && (flight.arr_actual != "") {
                    
                    if (flight.arr_delay != nil) && (flight.arr_delay != 0) {
                    
                        Text("Arr: ").font(.system(size: 15, weight: .regular)) + Text("\(flight.arr_actual ?? "Error")")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                        
                    } else {
                        
                        Text("Arr: ").font(.system(size: 15, weight: .regular)) + Text("\(flight.arr_actual ?? "Error")")
                            .font(.system(size: 15, weight: .regular))
                        
                    }
                    
                } else {
                    
                    if (flight.arr_delay != nil) && (flight.arr_delay != 0) {
                    
                        Text("Arr (Est.): ").font(.system(size: 15, weight: .regular)) + Text("\(flight.arr_estimated)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.05, blue: 0.05, alpha: 1)))
                        
                    } else {
                        
                        Text("Arr (Est.): ").font(.system(size: 15, weight: .regular)) + Text("\(flight.arr_estimated)")
                            .font(.system(size: 15, weight: .regular))
                        
                    }
                    
                }
                
                if flight.terminal == "S" {
                    
                    Text("Terminal: South (\(flight.flight_iata))").font(.system(size: 15, weight: .regular))
                    
                } else {
                    
                    Text("Terminal: North (\(flight.flight_iata))").font(.system(size: 15, weight: .regular))
                    
                }
                
            }
            .padding()
            
            Spacer()
            
            //Forward
            Image("Forward Arrow (Big)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipped()
            .frame(width: 50, height: 50)
            .padding()
        }
    }
}

let example_flight = Flight(
dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 0, arr_scheduled: "3:42", arr_estimated: "3:57", arr_actual: "4:00", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

struct FlightCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        FlightCardView(flight: example_flight)
    }
}
