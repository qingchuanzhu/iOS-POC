//
//  IntentHandler.swift
//  RideRequestExtension
//
//  Created by Qingchuan Zhu on 1/6/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Intents
import WenderLoonCore

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
  
  let simulator = WenderLoonSimulator(renderer: nil)
  
  override func handler(for intent: INIntent) -> Any? {
    if intent is INRequestRideIntent {
      return RideRequestHandler(simulator: self.simulator)
    }
    return .none
  }
}

