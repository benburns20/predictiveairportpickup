//
//  FlightListView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import SwiftUI
import OrderedCollections

struct SearchFlightView: View {
    
    @ObservedObject var manager: LocationManager
    @ObservedObject var airlinesModel = AirlinesModel()
    @ObservedObject var airportsModel = AirportsModel()
    @ObservedObject var airportTimeModel: AirportTimeModel
    @ObservedObject var airportTimeBaggageModel: AirportTimeBaggageModel
    
    @State var searchMode: Int
    @State var airportSelected = ""
    @State var airlineSelected = ""
    @State var flightCode = ""
    @State var selectedDate = Date()
    @State var dateChanged = false
    @State var searched = false
    @State var flightsSearched: [Flight] = []
    @State var loading = false
    
    @Binding var rootIsActive: Bool
    
    
    let example_flight3 = Flight(
    dep_airport: "Denver International", dep_iata: "DEN", dep_gate: "D13", dep_delay: 15, dep_scheduled: "12:19", dep_estimated: "12:34", dep_actual: "12:34", arr_airport: "Hartsfield-Jackson International", arr_iata: "ATL", arr_gate: "D31", arr_delay: 15, arr_scheduled: "3:42", arr_estimated: "3:57", airline: "Delta", flight_number: 1432, flight_iata: "DL1432")

    
    var body: some View {
        ZStack {
            VStack {
                switch searchMode {
                case 0:
                    ByAirportView(airportsModel: airportsModel, manager: manager, rootIsActive: $rootIsActive, airportSelected: $airportSelected, selectedDate: $selectedDate, dateChanged: $dateChanged)
                    
                case 1:
                    ByFlightCodeView(airlinesModel: airlinesModel, manager: manager, rootIsActive: $rootIsActive, airlineSelected: $airlineSelected, selectedDate: $selectedDate, dateChanged: $dateChanged, flightCode: $flightCode)
                    
                default:
                    ByAirportView(airportsModel: airportsModel, manager: manager, rootIsActive: $rootIsActive, airportSelected: $airportSelected, selectedDate: $selectedDate, dateChanged: $dateChanged)
                }
                
                Button("Search") {
                    Task {
                        if searched {
                            searched.toggle()
                        }
                        if airportSelected != "" && searchMode == 0 {
                            loading = true
                            flightsSearched = await getFlightsByAirportAPICall(date: selectedDate, dep_airport: airportSelected, airportsModel: airportsModel)
//                            print(flightsSearched)
                            loading = false
                            self.searched.toggle()
                        } else if flightCode != "" && searchMode == 1 {
                            loading = true
                            flightsSearched = await getFlightsByCodeAPICall(date: selectedDate, airline_code: airlineSelected, flight_code: flightCode, airportsModel: airportsModel)
//                            print(flightsSearched)
                            loading = false
                            self.searched.toggle()
                        }
                    }
                }
                    .buttonStyle(.borderedProminent)
                    .padding(40)
                
//                Spacer()
                
//                Text("Airline selected: \(airlineSelected)")
//                Text("Flight Code: \(flightCode)")
//                Text("Airport: \(airportSelected)")
//                Text("Code: \(airportsModel.airportsMapping[airportSelected] ?? "")")
//
//                NavigationLink(destination: FlightResultView(manager: manager, flight: example_flight3, rootIsActive: $rootIsActive)) {
//                    Text("Navigate to Flight Result View")
//                }
                if loading {
                    ProgressView{}
                }
                
                if searched {
                    if flightsSearched.isEmpty {
                        Text("No flights found")
                    }

                    SearchResultsView(rootIsActive: $rootIsActive, manager: manager, flights: Flights(flights_input: flightsSearched), airportTimeModel: airportTimeModel, airportTimeBaggageModel: airportTimeBaggageModel)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $searchMode) {
                    Text("By Route").tag(0)
                    Text("By Flight Code").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
            }
        }
        
//        .task {
//
//        }
    }
}

func getFlightsByAirportAPICall(date: Date, dep_airport: String, airportsModel: AirportsModel) async -> [Flight] {
    do {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let flight_date = formatter.string(from: Date())
//        print(flight_date)
        let dep_iata = airportsModel.airportsMapping[dep_airport]!
        
        let params: OrderedDictionary = [
            "access_key": "97c4f8a74c662b3f5dd391529c31ec67",
//            "limit": "10",
            "flight_date": flight_date,
            "dep_iata": dep_iata,
            "arr_iata": "ATL"
        ]
        
//        print(params)

        let flights = try await API.loadData(params: params)
//        if flights.data[0].departure?.delay != nil {
//            let delay = flights.data[0].departure?.delay
//            print(delay!)
//        }
        let flightArray = getFlightArrayFromJSON(flightJSON: flights)
        return flightArray
    } catch {
        print("error:", error)
        let emptyArray: [Flight] = []
        return emptyArray
    }
}

func getFlightsByCodeAPICall(date: Date, airline_code: String, flight_code: String, airportsModel: AirportsModel) async -> [Flight] {
    do {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let flight_date = formatter.string(from: Date())
        
        let params: OrderedDictionary = [
            "access_key": "97c4f8a74c662b3f5dd391529c31ec67",
//            "limit": "10",
            "flight_date": flight_date,
            "airline_iata": airline_code,
            "flight_number": flight_code
        ]
        
//        print(params)

        let flights = try await API.loadData(params: params)
//        if flights.data[0].departure?.delay != nil {
//            let delay = flights.data[0].departure?.delay
//            print(delay!)
//        }
        let flightArray = getFlightArrayFromJSON(flightJSON: flights)
        return flightArray
    } catch {
        print("error:", error)
        let emptyArray: [Flight] = []
        return emptyArray
    }
}

func getFlightArrayFromJSON(flightJSON: FlightDataJSON) -> [Flight] {
    var flights: [Flight] = []
    
    var duplicateArray: [String] = []
    
    let formatter1 = DateFormatter()
    formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
    
    let formatter2 = DateFormatter()
    formatter2.locale = Locale(identifier: "en_US_POSIX")
    formatter2.timeZone = TimeZone(abbreviation: "UTC")
    formatter2.dateFormat = "h:mm a"
    formatter2.amSymbol = "AM"
    formatter2.pmSymbol = "PM"
    
//    print(flightJSON)
//    print(flightJSON.data[0].departure?.airport)
    
    for flight in flightJSON.data {
        
//        print(duplicateArray)
//        print(flight.flight?.iata?.lowercased())
//        print(flight.flight?.codeshared?.flight_iata?.lowercased())
        
        if flight.flight?.iata == nil {
            continue
        }
        
        if duplicateArray.contains(flight.flight?.codeshared?.flight_iata?.lowercased() ?? "error") ||
            duplicateArray.contains(flight.flight?.iata?.lowercased() ?? "error") {
            continue
        }
        
        if flight.flight?.codeshared?.flight_iata != nil {
            let codesharedFlight = (flight.flight?.codeshared?.flight_iata)!
            duplicateArray.append(codesharedFlight)
        }
        
        let dep_scheduled = flight.departure?.scheduled ?? ""
        let dep_estimated = flight.departure?.estimated ?? ""
        let dep_actual = flight.departure?.actual ?? ""
        let arr_scheduled = flight.arrival?.scheduled ?? ""
        let arr_estimated = flight.arrival?.estimated ?? ""
        let arr_actual = flight.arrival?.actual ?? ""
        
        var timeArray: [String] = [
            dep_scheduled,
            dep_estimated,
            dep_actual,
            arr_scheduled,
            arr_estimated,
            arr_actual
        ]
        
//        print(timeArray)
        
        for (index, _) in timeArray.enumerated() {
//            print(timeArray[index])
            if timeArray[index] != "" {
                let dateTemp = formatter1.date(from: timeArray[index])
//                print(dateTemp)
                timeArray[index] = formatter2.string(from: dateTemp!)
            }
        }
        
//        print(timeArray)
        
        
        let newFlight = Flight(
            dep_airport: flight.departure?.airport ?? "",
            dep_iata: flight.departure?.iata ?? "",
            dep_gate: flight.departure?.gate,
            dep_delay: flight.departure?.delay,
            dep_scheduled: timeArray[0],
            dep_estimated: timeArray[1],
            dep_actual: timeArray[2],
            arr_airport: flight.arrival?.airport ?? "",
            arr_iata: flight.arrival?.iata ?? "",
            arr_gate: flight.arrival?.gate,
            arr_delay: flight.arrival?.delay,
            arr_scheduled: timeArray[3],
            arr_estimated: timeArray[4],
            arr_actual: timeArray[5],
            airline: flight.airline?.name ?? "",
            flight_number: Int(flight.flight?.number ?? "") ?? 0000,
            flight_iata: flight.flight?.iata ?? "",
            terminal: flight.arrival?.terminal ?? "",
            arr_estimated_date: flight.arrival?.estimated ?? "",
            arr_actual_date: flight.arrival?.actual
        )

        flights.append(newFlight)
    }
    
    return flights
}
