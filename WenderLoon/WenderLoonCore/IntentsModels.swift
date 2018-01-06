//
//  IntentsModels.swift
//  WenderLoonCore
//
//  Created by Qingchuan Zhu on 1/6/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Intents

// 1
public extension UIImage {
  public var inImage: INImage {
    return INImage(imageData: UIImagePNGRepresentation(self)!)
  }
}

// 2
public extension Driver {
  public var rideIntentDriver: INRideDriver {
    return INRideDriver(
      personHandle: INPersonHandle(value: name, type: .unknown),
      nameComponents: .none,
      displayName: name,
      image: picture.inImage,
      rating: rating.toString,
      phoneNumber: .none)
  }
}

public extension Balloon {
  public var rideIntentVehicle: INRideVehicle {
    let vehicle = INRideVehicle()
    vehicle.location = location
    vehicle.manufacturer = "Hot Air Balloon"
    vehicle.registrationPlate = "B4LL 00N"
    vehicle.mapAnnotationImage = image.inImage
    return vehicle
  }
}
