//
//  ViewController.swift
//  GoogleMapRadius
//
//  Created by Inkswipe on 6/4/18.
//  Copyright © 2018 Fortune4 Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController,CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var monitoredRegions: Dictionary<String, Date> = [:]
    @IBOutlet weak var mapview: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for monitored in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: monitored)
        }
        
        self.mapview.delegate = self
        self.mapview.isMyLocationEnabled = true
        self.mapview.settings.compassButton = true
        self.mapview.settings.myLocationButton = true
        self.mapview.mapType = .satellite
       
        
    }
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "location.png")
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        //changing the tint color of the image
        marker.position = position
        marker.iconView = markerView
        marker.title = "Near Me"
        //marker.snippet = ""
        marker.map = self.mapview
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let co1 =  CLLocationCoordinate2D(latitude: 19.108204576579546, longitude: 73.019691444933414)
        self.showMarker(position: co1)
        
        let co12 = CLLocationCoordinate2D(latitude: 19.107524082124634, longitude: 73.019158020615578)
        self.showMarker(position: co12)
        drawCircle(position: co1)
        drawCircle(position: co12)
        getCurrentLocaton(position: co1, nameRegion: "Kondiram location")
        getCurrentLocaton(position: co12, nameRegion: "Hotel location")
        
        
         let co123 = CLLocationCoordinate2D(latitude: 19.108383253430425, longitude: 73.019530512392521)
        
        self.showMarker(position: co123)
        drawCircle(position: co123)
        getCurrentLocaton(position: co123, nameRegion: "Car location")
        
        let co1234 =   CLLocationCoordinate2D(latitude: 19.107133778641177, longitude: 73.019633777439594)
        
        self.showMarker(position: co1234)
        drawCircle(position: co1234)
        getCurrentLocaton(position: co1234, nameRegion: "Table tainis player location")
        
        
        let co12345 =   CLLocationCoordinate2D(latitude: 19.107873517010567, longitude: 73.019065149128437)
        
        self.showMarker(position: co12345)
        drawCircle(position: co12345)
        getCurrentLocaton(position: co12345, nameRegion: "Bulding location")
        
        
        let co123456 =   CLLocationCoordinate2D(latitude: 19.108153571272869, longitude: 73.019267991185188)
        
        self.showMarker(position: co123456)
        drawCircle(position: co123456)
        getCurrentLocaton(position: co123456, nameRegion: "Open Space location")
        
      
    }
    func drawCircle(position:CLLocationCoordinate2D)  {
        
        let circleCenter = position//CLLocationCoordinate2D(latitude: 19.108204576579546, longitude: 73.019691444933414)
        let circ = GMSCircle(position: circleCenter, radius: 10)
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.4)
        circ.strokeColor = .red
        circ.strokeWidth = 2
        circ.map = self.mapview
        
    }
    
    
    
    func getCurrentLocaton(position:CLLocationCoordinate2D,nameRegion:String)  {
        
        
      
//        let latitude: CLLocationDegrees = 19.108204576579546
//        let longitude: CLLocationDegrees = 73.019691444933414
        let center: CLLocationCoordinate2D = position //CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(10)
        let identifier: String = nameRegion
        let currRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currRegion.notifyOnEntry = true
        currRegion.notifyOnExit = true
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startMonitoring(for: currRegion)
        locationManager.startUpdatingLocation()
        
       
        
    }
    
   
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("The monitored regions are: \(manager.monitoredRegions)")
    }
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)  {
//        //showAlert("Entered \(region.identifier)")
//        print("Entered")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//         //showAlert("Exited \(region.identifier)")
//        print("Exited")
//    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //showAlert("enter \(region.identifier)")
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.handleEvent1(forRegion: region)
        }

        monitoredRegions[region.identifier] = Date()
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        showAlert("exit \(region.identifier)")
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.handleEvent1(forRegion: region)
        }

        monitoredRegions.removeValue(forKey: region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for r in manager.monitoredRegions
        {
            if let cr = r as? CLCircularRegion
            {
                if cr.contains(locations[0].coordinate)
                {

                    if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                        myDelegate.handleEvent(forRegion: cr)
                    }

                     //showAlert("Am in the region! \(cr.identifier)")
                }
                else
                {
//                    let crLoc = CLLocation(latitude: cr.center.latitude,
//                                           longitude: cr.center.longitude)
//                    showAlert("distance is \(locations[0].distance(from: crLoc))")

                }
            }
        }
        //showAlert("didUpdateLocations ")
        //updateRegionsWithLocation(locations[0])
    }
    
    // MARK: - Comples business logic
    
    func updateRegionsWithLocation(_ location: CLLocation) {
        
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("Thanks for visiting our restaurant")
                
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValue(forKey: regionIdentifier)
        }
    }
    
    // MARK: - Helpers
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
extension ViewController: GMSMapViewDelegate{
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print(coordinate)
        //self.showMarker(position: coordinate)
    }
    
    
    
}

extension String {
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
