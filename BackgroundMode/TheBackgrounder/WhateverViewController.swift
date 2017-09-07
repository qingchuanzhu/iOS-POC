/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

class WhateverViewController: UIViewController {
  
  var previous = NSDecimalNumber.one
  var current = NSDecimalNumber.one
  var position: UInt = 1
  var updateTimer: Timer?
  
  var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
  
  @IBOutlet var resultsLabel: UILabel!
  
  @IBAction func didTapPlayPause(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    if sender.isSelected {
      resetCalculation()
      updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                         selector: #selector(calculateNextNumber), userInfo: nil, repeats: true)
      // register background task
      registerBackgroundTask()
    } else {
      updateTimer?.invalidate()
      updateTimer = nil
      // end background task
      endBackgroundTask()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  func calculateNextNumber() {
    let result = current.adding(previous)
    
    let bigNumber = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
    if result.compare(bigNumber) == .orderedAscending {
      previous = current
      current = result
      position += 1
    } else {
      // This is just too much.... Start over.
      resetCalculation()
    }
    
    let resultsMessage = "Position \(position) = \(current)"
    switch UIApplication.shared.applicationState {
    case .active:
      resultsLabel.text = resultsMessage
    case .background:
      print("App is backgrounded. Next number = \(resultsMessage)")
      print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
    case .inactive:
      break
    }
  }
 
  func reinstateBackgroundTask() {
    if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
      registerBackgroundTask()
    }
  }
  
  func resetCalculation() {
    previous = NSDecimalNumber.one
    current = NSDecimalNumber.one
    position = 1
  }
  
  func registerBackgroundTask() {
    backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
      self?.endBackgroundTask()
    }
    assert(backgroundTask != UIBackgroundTaskInvalid)
  }
  
  func endBackgroundTask() {
    print("Background task ended.")
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = UIBackgroundTaskInvalid
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
