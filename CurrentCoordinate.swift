//
//  CurrentLocation.swift
//  TorontoBike
//
//  Created by HSIAO JENHAO on 2017-08-17.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class CurrentCoordinate :NSObject ,MKMapViewDelegate, CLLocationManagerDelegate,getLoction {

    public static let sharedInstance = CurrentCoordinate()
    public static var mapManager = CLLocationManager()
    public static var currentLoction = CLLocationCoordinate2D()

    var lat : Double = 0
    var lon : Double = 0


    override init(){
        super.init()

        CurrentCoordinate.mapManager.delegate = self
        //

     
        if CLLocationManager.authorizationStatus() == .denied ||
            CLLocationManager.authorizationStatus() == .notDetermined {
            CurrentCoordinate.mapManager.requestWhenInUseAuthorization()
            CurrentCoordinate.mapManager.requestAlwaysAuthorization()
            CurrentCoordinate.mapManager.startUpdatingLocation()
        }

        CurrentCoordinate.mapManager.desiredAccuracy = kCLLocationAccuracyBest
        CurrentCoordinate.mapManager.requestWhenInUseAuthorization()
        CurrentCoordinate.mapManager.startUpdatingLocation()
        CurrentCoordinate.mapManager.activityType = .automotiveNavigation
        
        self.lat = CurrentCoordinate.currentLoction.latitude
        self.lon = CurrentCoordinate.currentLoction.longitude
        

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

        CurrentCoordinate.currentLoction = locations[0].coordinate
//
//        self.lat = CurrentCoordinate.currentLoction.latitude
//        self.lon = CurrentCoordinate.currentLoction.longitude


        if self.lat != 0.0 {

        CurrentCoordinate.mapManager.stopUpdatingLocation()
        }

        getLoction()

    }


    func getLoction(){

        let delayTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.global().asyncAfter(deadline: delayTime, execute: {

            self.lat = CurrentCoordinate.currentLoction.latitude
            self.lon = CurrentCoordinate.currentLoction.longitude


            if self.lat != 0.0 {

                print("CurrentCoordinate class, Location is ready")

            }else {

                print("CurrentCoordinate class, Location NOT ready, try again")

                self.checkAgain()
            }
        })
        
    }
    
    func checkAgain(){
        
        self.getLoction()
        
    }





}
