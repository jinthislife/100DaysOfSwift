//
//  ViewController.swift
//  Project22
//
//  Created by LeeKyungjin on 15/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var beaconIDLabel: UILabel!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circleView: UIView!

    var locationManager: CLLocationManager?
    var isFirstBeaconDetected = false

    let beacons: [(UUID, String, UInt16?, UInt16?)] = [    //(uuid, identifier, major, minor)
        (UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, "iPhone beacon", nil, nil),
        (UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, "iPad beacon", nil, nil),
        (UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, "MacBook beacon", nil, nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .white
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 128
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !isFirstBeaconDetected {
                isFirstBeaconDetected = true
                showFirstBeaconDetectAlert()
            }
            beaconIDLabel.text = region.identifier
            print("Becon detected: \(beacon.proximityUUID.uuidString) -\(region.identifier)")
            update(distance: beacon.proximity)
        }
    }
    
    func startScanning() {
        for (uuid, identifier, major, minor) in beacons {
            print(identifier)
            let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major ?? 123, minor: minor ?? 456, identifier: identifier)
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1, animations: {
                switch distance {
                case .far:
                    self.circleView.backgroundColor = UIColor.blue
                    self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.distanceReading.text = "FAR"
                    
                case .near:
                    self.circleView.backgroundColor = UIColor.orange
                    self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.distanceReading.text = "NEAR"
                    
                case .immediate:
                    self.circleView.backgroundColor = UIColor.red
                    self.circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.distanceReading.text = "RIGHT HERE"
                    
                default:
                    self.circleView.backgroundColor = UIColor.gray
                    self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    self.distanceReading.text = "UNKNOWN"
                }
        })
    }
    
    func showFirstBeaconDetectAlert() {
        let ac = UIAlertController(title: "Alert", message: "Beacon detected!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

