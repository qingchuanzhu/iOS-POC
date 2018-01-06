//
//  RideRequestHandler.swift
//  RideRequestExtension
//
//  Created by Qingchuan Zhu on 1/6/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Intents

class RideRequestHandler:
NSObject, INRequestRideIntentHandling {
  func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
   let response = INRequestRideIntentResponse(code: .failureRequiringAppLaunchNoServiceInArea, userActivity: .none)
    completion(response)
  }
}
