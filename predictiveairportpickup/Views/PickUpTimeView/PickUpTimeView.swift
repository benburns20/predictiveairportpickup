//
//  PickUpTimeView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/31/22.
//

import SwiftUI
import MapKit

struct PickUpTimeView: View {
    @Binding var shouldPopToRootView : Bool
    
    @State var pickerState = 0
    @State var travelTime = 0.0
    @State var noBaggageTime = 0
    @State var baggageTime = 0
    
    @ObservedObject var manager: LocationManager
    @ObservedObject var flight: Flight
    @ObservedObject var airportTimeModel: AirportTimeModel
    @ObservedObject var airportTimeBaggageModel: AirportTimeBaggageModel
    
    func getTimeToLeave(state: Int, noBaggage: Int, baggage: Int, travelTime: Double) -> String {
        var landingTimeString = ""
        if flight.arr_actual_date != "" && flight.arr_actual_date != nil {
            landingTimeString = flight.arr_actual_date!
        } else {
            landingTimeString = flight.arr_estimated_date
        }
        
//        print(flight.arr_estimated)
//        print(flight.arr_estimated_date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let landingTimeDate: Date = formatter.date(from: landingTimeString)!
        
        var finalTime = landingTimeDate
        
        if state == 0 {
            finalTime += Double(noBaggage) * 60.0
        } else {
            finalTime += Double(baggage) * 60.0
        }
        
        predictiveairportpickup.MainView.tracked_flight.pickUpTime = finalTime
        
//        print(noBaggage)
//        print(baggage)
        
//        print("Time to pick up: \(finalTime)")
        
//        print("Travel time: \(travelTime)")
        
        let timeToArrive = finalTime - travelTime
        
//        print("timetoarrive: \(timeToArrive)")
//        print("current date: \(Date())")
        
        if (timeToArrive.compare(Date(timeIntervalSinceNow: -14400)) == .orderedAscending) {
            return "Now"
        } else {
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "h:mm a"
            formatter2.amSymbol = "AM"
            formatter2.pmSymbol = "PM"
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.timeZone = TimeZone(abbreviation: "UTC")
            return formatter2.string(from: timeToArrive)
        }
    }
    
    var body: some View {
        
        //Estimated Pick-Up Time:
        Text("Estimated\nPick-Up Time:")
            .font(.system(size: 30, weight: .regular))
            .multilineTextAlignment(.center)
        
        CustomSegmentedControl(selection: $pickerState, size: CGSize(width: 300, height: 200), segmentLabels: [noBaggageTime, baggageTime])
            .onAppear() {
                noBaggageTime = airportTimeModel.getAirportTimes()
                baggageTime = airportTimeBaggageModel.getAirportTimesBaggage()
//                print("NoB: \(noBaggageTime), B: \(baggageTime)")
            }
        
        //You Should Leave From Your...
        Text("You Should Leave At:")
            .font(.system(size: 25, weight: .regular))
            .multilineTextAlignment(.center)
            .onAppear() {
                predictiveairportpickup.MainView.tracked_flight.flight = flight
            }
        
        //8:07 PM
        if travelTime == 0.0 || baggageTime == 0 || noBaggageTime == 0 {
            Text("Thinking...")
                .font(.system(size: 50, weight: .bold))
                .multilineTextAlignment(.center)
        } else {
            Text(getTimeToLeave(state: pickerState, noBaggage: noBaggageTime, baggage: baggageTime, travelTime: travelTime))
                .font(.system(size: 50, weight: .bold))
                .multilineTextAlignment(.center)
        }

        MapToAirport(manager: manager, flight: flight, travelTime: $travelTime)
        
        Button("Picked Up?") {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "EST")
            
            var landingTimeDate: Date = Date()
            
            if flight.arr_actual_date != "" && flight.arr_actual_date != nil {
//                print(flight.arr_actual_date!)
                landingTimeDate = formatter.date(from: flight.arr_actual_date!)!
            } else {
//                print(flight.arr_estimated_date)
                landingTimeDate = formatter.date(from: flight.arr_estimated_date)!
            }
            
//            print(Date(timeIntervalSinceNow: -14400))
//            print(landingTimeDate)
            
            let timeInAirport = (Date(timeIntervalSinceNow: -14400).timeIntervalSinceReferenceDate - landingTimeDate.timeIntervalSinceReferenceDate) / 60
            
//            print(timeInAirport)
            
            if pickerState == 0 {
                airportTimeModel.createAirportTime(time: timeInAirport)
            } else {
                airportTimeBaggageModel.createAirportTimeBaggage(time: timeInAirport)
            }

            MainView.tracked_flight.pickUpTime = nil
            MainView.tracked_flight.flight = nil

            self.shouldPopToRootView = false
            
        }
        .padding()
        
        Button(action: {
            self.shouldPopToRootView = false
        }) {
            Text("Navigate back to Main Screen")
        }
    }
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct MapToAirport: View {
    @ObservedObject var manager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    
    @ObservedObject var flight: Flight
    
    @Binding var travelTime: TimeInterval
    
    var body: some View {
//        Map(coordinateRegion: $manager.region, interactionModes: MapInteractionModes.all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: getMapMarker()) { marker in
//            marker.location
//        }
//            .frame(width: UIScreen.main.bounds.size.width - 70, height: 200)
//            .cornerRadius(10)
        
        Text("Time to Airport: \(getETAString(eta: travelTime))")
            .onAppear(perform: {
                getETAToAirport()
            })
        
        Button("Travel to Airport?") {
            goToMap()
        }
        .buttonStyle(.borderedProminent)
        .frame(width: 257, height: 59)
    }
    
    
    
    let launchOptions = [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
      ]
    let hartsfieldSouth = CLLocationCoordinate2D(latitude: 33.640036, longitude: -84.443821)
    let hartsfieldNorth = CLLocationCoordinate2D(latitude: 33.64187427605757, longitude: -84.44769382797817)
    
    func getETAString(eta: TimeInterval) -> String {
        if eta == 0.0 {
            return "Calculating..."
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        
        return (formatter.string(from: eta) ?? "0") + " min"
    }
    
    func getMapMarker() -> [Marker] {
        if flight.terminal == "S" {
            return [Marker(location: MapMarker(coordinate: hartsfieldSouth))]
        } else {
            return [Marker(location:MapMarker(coordinate: hartsfieldNorth))]
        }
    }
    
    func goToMap() {
        var item = MKMapItem.init(placemark: MKPlacemark(coordinate: hartsfieldSouth))
        
        if flight.terminal == "S" {
            item.name = "South Terminal"
        } else {
            item = MKMapItem.init(placemark: MKPlacemark(coordinate: hartsfieldNorth))
            item.name = "North Terminal"
        }
        
        item.openInMaps(launchOptions: launchOptions)
    }
    
    func getETAToAirport() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: manager.region.center))
        if flight.terminal == "S" {
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: hartsfieldSouth))
        } else {
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: hartsfieldNorth))
        }
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculateETA { response, error in
            if response != nil {
                travelTime = response!.expectedTravelTime
            }
        }
    }
}
