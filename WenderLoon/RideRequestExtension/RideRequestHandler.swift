//
//  RideRequestHandler.swift
//  RideRequestExtension
//
//  Created by Qingchuan Zhu on 1/6/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Intents
import WenderLoonCore

class RideRequestHandler:
NSObject, INRequestRideIntentHandling {
  
  let simulator: WenderLoonSimulator
  
  init(simulator: WenderLoonSimulator) {
    self.simulator = simulator
    super.init()
  }
  
  func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
   let response = INRequestRideIntentResponse(code: .failureRequiringAppLaunchNoServiceInArea, userActivity: .none)
    completion(response)
  }
  
  func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
    if let pickup = intent.pickupLocation {
      completion(.success(with: pickup))
    } else {
      completion(.needsValue())
    }
  }
  
  func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
    if let dropOff = intent.dropOffLocation {
      completion(.success(with: dropOff))
    } else {
      completion(.notRequired())
    }
  }
  
  func resolvePartySize(for intent: INRequestRideIntent, with completion: @escaping (INIntegerResolutionResult) -> Void) {
    switch intent.partySize {
    case .none:
      completion(.needsValue())
    case let .some(p) where simulator.checkNumberOfPassengers(p):
      completion(.success(with: p))
    default:
      completion(.unsupported())
    }
  }
  
  func confirm(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
    let responseCode: INRequestRideIntentResponseCode
    if let location = intent.pickupLocation?.location,
      simulator.pickupWithinRange(location) {
      responseCode = .ready
    } else {
      responseCode = .failureRequiringAppLaunchNoServiceInArea
    }
    let response = INRequestRideIntentResponse(code: responseCode, userActivity: nil)
    completion(response)
  }
}
