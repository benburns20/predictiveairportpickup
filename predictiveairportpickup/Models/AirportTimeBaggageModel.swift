//
//  AirportTimeModel.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import Foundation
import SwiftUI
import Amplify
import Combine

final class AirportTimeBaggageModel: ObservableObject {
    
    @Published var airportTimes: [Double] = []
    @Published var average: Int = 0
    
    @State var airportTimeBaggageSubscription: AnyCancellable?

    func subscribeAirportTimesBaggage() {
        self.airportTimeBaggageSubscription
        = Amplify.DataStore.publisher(for: AirportTimeBaggage.self)
            .sink(receiveCompletion: { completion in
                print("Subscription has been completed: \(completion)")
            }, receiveValue: { mutationEvent in
                print("Subscription got this value: \(mutationEvent)")
                
                do {
                    let airportTimeBaggage = try mutationEvent.decodeModel(as: AirportTimeBaggage.self)
                    
                    switch mutationEvent.mutationType {
                    case "create":
                        print("Created: \(airportTimeBaggage)")
                    case "update":
                        print("Updated: \(airportTimeBaggage)")
                    case "delete":
                        print("Deleted: \(airportTimeBaggage)")
                    default:
                        break
                    }
                } catch {
                    print("Model could not be decoded: \(error)")
                }
            })
    }
    
    func getAirportTimesBaggage() -> Int {
        Amplify.DataStore.query(AirportTimeBaggage.self,  where: AirportTimeBaggage.keys.time.gt(0)) { result in
            switch result {
            case .success(let airportTimes):
                self.airportTimes.removeAll()
                for item in airportTimes {
                    self.airportTimes.append(item.time)
                }
//                print("QUERY: \(self.airportTimes)")
                if !self.airportTimes.isEmpty {
                    self.average = Int(round(Double(self.airportTimes.reduce(0, +)) / Double(self.airportTimes.count)))
//                    print(Int(round(Double(self.airportTimes.reduce(0, +)) / Double(self.airportTimes.count))))
                }
            case .failure(let error):
                print(error)
            }
        }
        
        return self.average
    }

    func createAirportTimeBaggage(time: Double) {
        let item = AirportTimeBaggage(time: time)
        Amplify.DataStore.save(item) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.time)")
            case .failure(let error):
                print("Could not save item to DataStore: \(error)")
            }
        }
    }

    func fetchCurrentAuthSession() -> AnyCancellable {
        Amplify.Auth.fetchAuthSession().resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Fetch session failed with error \(authError)")
                }
            }
            receiveValue: { session in
                print("Fetching...")
                print("Is user signed in - \(session.isSignedIn)")
            }
    }
}
