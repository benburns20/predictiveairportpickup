//
//  Flight.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import Foundation
import OrderedCollections

class Flight: ObservableObject, Identifiable {
    
    init(dep_airport: String = "", dep_iata: String = "", dep_gate: String? = "", dep_delay: Int? = 0, dep_scheduled: String = "", dep_estimated: String = "", dep_actual: String? = "", arr_airport: String = "", arr_iata: String = "", arr_gate: String? = "", arr_delay: Int? = 0, arr_scheduled: String = "", arr_estimated: String = "", arr_actual: String? = "", airline: String = "", flight_number: Int = 0000, flight_iata: String = "", terminal: String = "", arr_estimated_date: String = "", arr_actual_date: String? = "") {
        self.dep_airport = dep_airport
        self.dep_iata = dep_iata
        self.dep_gate = dep_gate
        self.dep_delay = dep_delay
        self.dep_scheduled = dep_scheduled
        self.dep_estimated = dep_estimated
        self.dep_actual = dep_actual
        self.arr_airport = arr_airport
        self.arr_iata = arr_iata
        self.arr_gate = arr_gate
        self.arr_delay = arr_delay
        self.arr_scheduled = arr_scheduled
        self.arr_estimated = arr_estimated
        self.arr_actual = arr_actual
        self.airline = airline
        self.flight_number = flight_number
        self.flight_iata = flight_iata
        self.terminal = terminal
        self.arr_estimated_date = arr_estimated_date
        self.arr_actual_date = arr_actual_date
    }
    

    let id = UUID()
    
    var dep_airport: String = ""
    var dep_iata: String = ""
    @Published var dep_gate: String? = ""
    @Published var dep_delay: Int? = 0
    @Published var dep_scheduled: String = ""
    @Published var dep_estimated: String = ""
    @Published var dep_actual: String? = ""
    
    var arr_airport: String = ""
    var arr_iata: String = ""
    @Published var arr_gate: String? = ""
    @Published var arr_delay: Int? = 0
    @Published var arr_scheduled: String = ""
    @Published var arr_estimated: String = ""
    @Published var arr_actual: String? = ""
    
    var airline: String = ""
    var flight_number: Int = 0000
    var flight_iata: String = ""
    var terminal: String = ""
    
    var arr_estimated_date: String = ""
    var arr_actual_date: String? = ""
}


class API: ObservableObject {
    @Published var flights = [Flight]()
    
    static func loadData(params: OrderedDictionary<String, String>) async throws -> FlightDataJSON {
        
//        print(params)
        
        guard var url = URLComponents(string: "https://api.aviationstack.com/v1/flights") else {fatalError("Missing URL")}
            url.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
//            print(url.url!)
            let request = URLRequest(url: url.url!)
        
            let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw DecodeError.notdecoded}
//            print(try JSONSerialization.jsonObject(with: data))
            let flights = try JSONDecoder().decode(FlightDataJSON.self, from: data)
            print("Searching...")
            return flights
//        print(request)
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            print("Check 1")
//
//            let flights = (try! JSONDecoder().decode(FlightDataJSON.self, from: data!))
//            print("check 2")
//            DispatchQueue.main.async {
//                completion(flights, error)
//            }
//            guard
//                let data = data,
//                let response = response as? HTTPURLResponse,
//                200 ..< 300 ~= response.statusCode,
//                error == nil
//            else {
//                print("oops")
//                completion(nil, error)
//                return
//            }
//
//            print(data)
//
//            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
//            completion(responseObject, nil)
    }
}

enum DecodeError: Error {
    case notdecoded
}

