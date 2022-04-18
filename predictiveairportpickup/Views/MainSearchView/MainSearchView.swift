//
//  ContentView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import SwiftUI
import Amplify
import Combine

struct MainSearchView: View {
    
    @ObservedObject var airportTimeModel = AirportTimeModel()
    @ObservedObject var airportTimeBaggageModel = AirportTimeBaggageModel()
    
    @State var currentPickupSelected = predictiveairportpickup.MainView.tracked_flight.flight != nil
    @State private var showingResultView = false
    @State private var showingTutorial = false
    @State var isActive1: Bool = false
    @State var isActive2: Bool = false
    
    @State var responseObject: [String: Any] = [
        "test": 0
    ]
    
    @StateObject var manager = LocationManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                VStack {
                    //Predictive Airport Pickup
                    Text("Predictive Airport Pickup")
                        .font(.system(size: 52, weight: .heavy))
                        .multilineTextAlignment(.center)
                        .padding([.bottom], 50)
                    
                    //Begin Your Search:
                    Text("Begin Your Search:").font(.system(size: 30, weight: .regular)).multilineTextAlignment(.center)
                    
                    NavigationLink (destination: SearchFlightView(manager: manager, airportTimeModel: airportTimeModel, airportTimeBaggageModel: airportTimeBaggageModel, searchMode: 0, rootIsActive: $isActive1), isActive: $isActive1) {
                        ZStack {
                            Button("") {
                                
                            }
                                .frame(width: UIScreen.main.bounds.size.width - 70, height: 40)
                                .foregroundColor(.gray)
                                .background(Color("Gray"))
                                .cornerRadius(13)
                            
                            HStack {
                                //Placeholder
                                Text("Flight Search")
                                    .font(.system(size: 20, weight: .regular))
                                    .tracking(0.38)
                                Image("Forward Arrow")
                            }
                                .foregroundColor(.gray)
                                .padding(.leading, 13)
                            
                        }
                            .frame(height: 40)
                            .padding([.leading, .trailing])
                    }
                    .isDetailLink(false)
                    
//                    Button(action: {
//                        print(predictiveairportpickup.MainView.tracked_flight.flight?.flight_number ?? 9999)
//                    }) {
//                        Text("Print Flight info")
//                    }
                    
                    if currentPickupSelected {
                        
                        Text("or")
                            .font(.system(size: 30, weight: .regular))
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: PickUpTimeView(shouldPopToRootView: $isActive2, manager: manager, flight: predictiveairportpickup.MainView.tracked_flight.flight!, airportTimeModel: airportTimeModel, airportTimeBaggageModel: airportTimeBaggageModel), isActive: $isActive2) {
                            ZStack {
                                Button("") {
                                    
                                }
                                    .frame(width: UIScreen.main.bounds.size.width - 90, height: 110)
                                    .foregroundColor(.gray)
                                    .background(Color("Gray"))
                                    .cornerRadius(20)
                                
                                FlightCardView(flight: predictiveairportpickup.MainView.tracked_flight.flight!)
                                    .frame(width: UIScreen.main.bounds.size.width - 90)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        HStack {
                            Text("Pickup by:")
                                .font(.system(size: 25, weight: .regular))
                            
                            Text(getTimeText(pickUpTime: predictiveairportpickup.MainView.tracked_flight.pickUpTime!))
                                .font(.system(size: 30, weight: .bold))
                        }
                        
                        Button("Picked Up?") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .padding([.bottom])
                        
                        Button("Clear Tracked Flight") {
                            predictiveairportpickup.MainView.tracked_flight.flight = nil
                            currentPickupSelected = false
                        }
                        
                    } else {
                        VStack {}
                            .frame(height: 178)
                    }
    //                NavigationLink(destination: FlightResultView()) {
    //                    Text("Flight List")
    //                }
    //
//                    Button(action: {
//                        airportTimeModel.getAirportTimes()
//                        airportTimeBaggageModel.getAirportTimesBaggage()
//                    }){
//                        Text("Print Airport Times")
//                    }
                    
                    Button(action: {
                        showingTutorial.toggle()
                    }){
                        Text("Help?")
                    }
                    .sheet(isPresented: $showingTutorial) {
                        TutorialView(showingTutorial: $showingTutorial)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear(perform: {
                currentPickupSelected = predictiveairportpickup.MainView.tracked_flight.flight != nil
//                airportTimeModel.clearLocalAirportTimes()
//                airportTimeModel.subscribeAirportTimes()
//                airportTimeBaggageModel.subscribeAirportTimesBaggage()
//                let params = [
//                    "access_key": "97c4f8a74c662b3f5dd391529c31ec67",
//                    "limit": "10",
//                    "flight_iata": "WN1175"
//                ]
//
//                API().loadData(params) { (responseObject, nil) in
//                    self.responseObject = responseObject ?? ["fail": 0]
//
//                    let flightData = self.responseObject["data"] as! NSArray
//
//                    print(responseObject)

//                    let data0 = flightData[0] as! NSDictionary
//
//                    let data0Dep = data0["departure"] as! NSDictionary
//                    let data0DepDelay = data0Dep["delay"] as! Int
//
//                    print(data0)
//                    print(type(of: data0))
//
//                    print(data0DepDelay)
//                    print(type(of: data0DepDelay))
//                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

let example_tracked_flight = Flight()

func getTimeText(pickUpTime: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter.string(from: pickUpTime)
}

struct MainSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainSearchView()
    }
}
