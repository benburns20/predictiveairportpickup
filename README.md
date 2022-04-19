# Predictive Airport Pickup App by Bennett Burns
## CS 4365/6365 Spring 2022 - Final Deliverables

### Description:

While data is readily available on flight times and delays, not much has been done for an equally important aspect of travel: the “pickup” at the airport. With the busy season around the corner, it is especially important that those picking up loved ones and friends are efficient and timely so as to reduce unnecessary traffic around airports as well as crowds within the airports.

The proposed project aimed to solve this problem by combining three key technologies in hopes to better predict the best time for a driver to leave for pickup at the terminal. First, using readily available flight data, the application calculates landing times of flights down to the minute, accounting for any delays from weather or airport technicalities. Second, using Apple Maps, the app calculates the distance and time it takes for the user to drive to the airport in order to give them the correct time to leave. Finally, in order to assess the “impossible-to-measure” time that is spent within the airport, be that walking from one terminal to another or baggage claim, the application uses previous, anonymized data to assess a correct prediction for wait time.

Note: It is important to highlight that the current iteration 

### Language Used:
  * **Swift** (specifically utilized SwiftUI framework)

### APIs Used for Features:
  * **Apple Maps** - for navigation to airport and ETA calculations - https://developer.apple.com/maps/
  * **aviationstack** - for flight tracking - https://aviationstack.com
  * **AWS Amplify** - for storage of predictive times (backend) - https://aws.amazon.com/amplify/

### Detailed Instructions:
  1. Start by searching for a flight via the **Flight Search** button
  2. From the Search screen, you can choose to search for flight by the **Departure** airport (i.e. LAX) or by the **Flight Code** (i.e. DL 2121)
  3. After pressing the Search button, select the **Flight** you wish to Pick Up for
  4. The following screen will show the **Flight** info, as well as a button to **Track the Current Flight**
  5. On the Flight Tracking screen, you will see the current Predicted Times for traveling through the airport, as well as a calculated time for you to leave from your current location
  6. *This will change depending on if your Pick Up will take into account **Baggage Claim** or not*
  7. Your tracked **Flight** will persist on the Home screen, and you may signal that you have picked up at the airport using the **Picked Up?** button
