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

let defaultAirportTimeNoBaggage = 30
let defaultAirportTimeBaggage = 45

final class AirportTimeModel: ObservableObject {
    
    @Published var airportTimes: [Double] = []
    @Published var average: Int = 0
    
    @State var airportTimeSubscription: AnyCancellable?
    
    func clearLocalAirportTimes() {
        Amplify.DataStore.clear() { result in
            switch result {
            case .success:
                print("Local data cleared successfully")
            case .failure(let error):
                print("Local data not cleared: \(error)")
            }
        }
    }

    func subscribeAirportTimes() {
        self.airportTimeSubscription
        = Amplify.DataStore.publisher(for: AirportTime.self)
            .sink(receiveCompletion: { completion in
                print("Subscription has been completed: \(completion)")
            }, receiveValue: { mutationEvent in
                print("Subscription got this value: \(mutationEvent)")
                
                do {
                    let airportTime = try mutationEvent.decodeModel(as: AirportTime.self)
                    
                    switch mutationEvent.mutationType {
                    case "create":
                        print("Created: \(airportTime)")
                    case "update":
                        print("Updated: \(airportTime)")
                    case "delete":
                        print("Deleted: \(airportTime)")
                    default:
                        break
                    }
                } catch {
                    print("Model could not be decoded: \(error)")
                }
            })
    }
    
    func getAirportTimes() -> Int {
        Amplify.DataStore.query(AirportTime.self, where: AirportTime.keys.time.gt(0)) { result in
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

    func createAirportTime(time: Double) {
        let item = AirportTime(time: time)
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
