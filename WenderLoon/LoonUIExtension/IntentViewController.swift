//
//  IntentViewController.swift
//  LoonUIExtension
//
//  Created by Qingchuan Zhu on 1/6/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import IntentsUI
import WenderLoonCore

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet var balloonImageView: UIImageView!
    @IBOutlet var driverImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - INUIHostedViewControlling
  func configure(with interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (CGSize) -> Void) {
    // 1
    guard let response = interaction.intentResponse as? INRequestRideIntentResponse
      else {
        driverImageView.image = nil
        balloonImageView.image = nil
        subtitleLabel.text = ""
        completion(self.desiredSize)
        return
    }
    
    // 2
    if let driver = response.rideStatus?.driver {
      let name = driver.displayName
      driverImageView.image = WenderLoonSimulator.imageForDriver(name: name)
      balloonImageView.image = WenderLoonSimulator.imageForBallon(driverName: name)
      subtitleLabel.text = "\(name) will arrive soon!"
    } else {
      // 3
      driverImageView.image = nil
      balloonImageView.image = nil
      subtitleLabel.text = "Preparing..."
    }
    
    // 4
    completion(self.desiredSize)
  }
    
    var desiredSize: CGSize {
        var defaultSize = self.extensionContext!.hostedViewMaximumAllowedSize
        defaultSize.height = 80
        return defaultSize
    }
    
}
