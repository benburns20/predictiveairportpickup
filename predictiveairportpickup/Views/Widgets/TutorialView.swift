//
//  TutorialView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/17/22.
//

import SwiftUI

struct TutorialView: View {
    
    @Binding var showingTutorial: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("How To Use:")
                    .font(.system(size: 40, weight: .bold))
                    .padding([.leading, .top])
                
                Text("Start by searching for a flight via the **Flight Search** button")
                    .font(.system(size: 20, weight: .regular))
                    .padding()
                
                Text("From the Search screen, you can choose to search for flight by the **Departure** airport (i.e. LAX) or by the **Flight Code** (i.e. DL 2121)")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing, .bottom])
                
                Text("After pressing the Search button, select the **Flight** you wish to Pick Up for")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing, .bottom])
                
                Text("The following screen will show the **Flight** info, as well as a button to **Track the Current Flight**.")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing, .bottom])
                
                Text("On the Flight Tracking screen, you will see the current Predicted Times for traveling through the airport, as well as a calculated time for you to leave from your current location")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing])
                
                Text("*This will change depending on if your Pick Up will take into account **Baggage Claim** or not*")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing, .bottom])
                
                Text("Your tracked **Flight** will persist on the Home screen, and you may signal that you have picked up at the airport using the **Picked Up?** button")
                    .font(.system(size: 20, weight: .regular))
                    .padding([.leading, .trailing])
            }
            .padding([.top, .bottom])
        }
    }
}

//struct TutorialView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialView(showingTutorial: showing)
//    }
//}
