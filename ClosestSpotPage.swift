//
//  ViewController.swift
//  TorontoBike
//
//  Created by HSIAO JENHAO on 2017-08-06.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ClosestSpotPage: UIViewController, UITableViewDelegate, UITableViewDataSource , MKMapViewDelegate{

    var SpotsTableView = UITableView()
    var mapViewFromList : MKMapView!

    var stationAnnotation = MKPointAnnotation()
    var myPostion = CurrentCoordinate()

    override func viewDidLoad() {
        super.viewDidLoad()


        let fullScreenSize = UIScreen.main.bounds.size
        self.view.backgroundColor = UIColor.lightGray


        sortKeysArrayByDistance()

        checkDataEmpty()

        //MARK: MapView

        mapViewFromList = MKMapView(frame: CGRect( x: 0, y: 0,
                                                   width: fullScreenSize.width,
                                                   height: fullScreenSize.height * 0.6 ))
        self.view.addSubview(mapViewFromList)

        //MARK: TableView


        SpotsTableView = UITableView(frame: CGRect( x: 0, y: fullScreenSize.height * 0.6,
                                                    width: fullScreenSize.width,
                                                    height: fullScreenSize.height * 0.4),
                                     style: .plain)

        //enroll History cell

        SpotsTableView.register(ClosestSpotCell.self, forCellReuseIdentifier: "SpotCell")
        // set the delegate

        SpotsTableView.delegate = self
        SpotsTableView.dataSource = self

        mapViewFromList.delegate = self
        mapViewFromList.mapType = MKMapType.standard

        //table view separator
        SpotsTableView.separatorStyle = .singleLine

        // separator space
        SpotsTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        SpotsTableView.allowsSelection = true
        SpotsTableView.allowsMultipleSelection = false
        self.view.addSubview(SpotsTableView)



        //MARK:Current location Button

        let btnCurrent = UIButton(type: .custom)
        btnCurrent.frame = CGRect( x: fullScreenSize.width  - 60, y: fullScreenSize.height * 0.50, width: 40, height: 40)
        btnCurrent.setImage(UIImage(named: "Current1"), for: .normal)
        btnCurrent.setTitle("Reload", for: .normal)
        btnCurrent.addTarget( nil, action: #selector(goCurrent), for: .touchDown)
        //        self.view.addSubview(btnCurrent)
        self.mapViewFromList.addSubview(btnCurrent)


        //MARK:Reload Button
        let btnReload = UIButton(type: .custom)
        btnReload.frame = CGRect( x: fullScreenSize.width  - 60, y: fullScreenSize.height * 0.82, width: 40, height: 40)
        btnReload.setImage(UIImage(named: "buttonReload"), for: .normal)
        btnReload.setTitle("Reload", for: .normal)
        btnReload.addTarget( nil, action: #selector(reloadSourceData), for: .touchDown)
        self.view.addSubview(btnReload)

        //MARK:Exit Button

        let btnExit = UIButton(type: .custom)
        btnExit.frame = CGRect( x: fullScreenSize.width  - 60, y: fullScreenSize.height * 0.92, width: 40, height: 40)
        btnExit.setImage(UIImage(named: "buttonBack"), for: .normal)
        btnExit.setTitle("Reload", for: .normal)
        btnExit.addTarget( nil, action: #selector(goBack), for: .touchDown)
        self.view.addSubview(btnExit)


    }


    func goCurrent(){

        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(
            CurrentCoordinate.currentLoction.latitude,
            CurrentCoordinate.currentLoction.longitude)

        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01

        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)

        mapViewFromList.setRegion(region, animated: true)
        self.mapViewFromList.showsUserLocation = true

    }


    override func viewWillAppear(_ animated: Bool) {


    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stationInfo.infoLocalDic.count
        return ClosetSportController.sharedInstance.infoLocalDic.count
    }




    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "SpotCell"
        let cell = SpotsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ClosestSpotCell



        let key = ClosetSportController.sharedInstance.keysArray[indexPath.row]
        print("key=",(key))

        let name = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationName
        let bikes = ClosetSportController.sharedInstance.statusLocalDic[key]?.bikesAvailable
        let docks = ClosetSportController.sharedInstance.statusLocalDic[key]?.docksAvailable
        let distance = ClosetSportController.sharedInstance.infoLocalDic[key]?.distance


        print("distance=",(distance)!)
        cell.satationName.text = name

        checkCellTextColor(cell: cell, bikes: bikes!,docks:docks!,distance:distance!)

        cell.bikesAvailable.text = String(describing: bikes!)
        cell.docksAvailable.text = String(describing: docks!)
        cell.distancelable.text = String(describing: distance!) + "km"

        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 50 / 255, green: 170 / 255 , blue: 110 / 255 , alpha: 1)
        cell.labelBikes.highlightedTextColor = UIColor.white
        cell.labelDocks.highlightedTextColor = UIColor.white
        cell.labelDistance.highlightedTextColor = UIColor.white
        cell.satationName.highlightedTextColor = UIColor.white


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let key = ClosetSportController.sharedInstance.keysArray[indexPath.row]
//        goTo(key: key!)
        showTwoLocation(key: key)
        //        calculateDistance(key: key!)
    }


    func goTo(key : String){

        let lat = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationLat
        let lon = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationLon

        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)

        // Span size
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)

        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        mapViewFromList.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.title = stationInfo.infoLocalDic[key]?.stationName
        annotation.title = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationName
        mapViewFromList.addAnnotation(annotation)

    }

    func reloadSourceData(){


        ClosetSportController.sharedInstance.keysArray.removeAll()
        ClosetSportController.sharedInstance.infoLocalDic.removeAll()
        ClosetSportController.sharedInstance.statusLocalDic.removeAll()
        ClosetSportController.sharedInstance.getSourceData()


        sortKeysArrayByDistance()
        self.SpotsTableView.reloadData()

        checkDataEmpty()

    }

    func checkDataEmpty(){


        if (ClosetSportController.sharedInstance.keysArray.count) <= 1 {
            alert(input: "Please check your network connectivity.")
        }else {
            alert(input: "Reload ok")
        }
    }

    func alert(input: String){


        let alert = UIAlertController(title:nil,message: input,preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alert.addAction(actionOK)

        self.present(alert, animated: true, completion:nil)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {

//        self.dismiss(animated: true, completion: nil)
        self.present(StartPage(), animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        goCurrent()
    }

    func showTwoLocation(key : String){

        mapViewFromList.removeAnnotation(stationAnnotation)

        let goalLat = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationLat
        let goalLon = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationLon
        let goalLocatoin = CLLocationCoordinate2D(latitude: goalLat!, longitude: goalLon!)
        let goalStationPlacemark = MKPlacemark(coordinate: goalLocatoin, addressDictionary: nil)
        let currentPlacemark = MKPlacemark(
            coordinate: CurrentCoordinate.currentLoction,
            addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: goalStationPlacemark)
        let destinationMapItem = MKMapItem(placemark: currentPlacemark)

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        print("directionRequest.destination=",(directionRequest.destination)!)
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.mapViewFromList.removeOverlays(self.mapViewFromList.overlays)
            self.mapViewFromList.add((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapViewFromList.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }



        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(goalLat!, goalLon!)
        stationAnnotation.coordinate = coordinate
        stationAnnotation.title = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationName
        mapViewFromList.addAnnotation(stationAnnotation)
        mapViewFromList.region.span.latitudeDelta =  mapViewFromList.region.span.latitudeDelta * 1.5
        mapViewFromList.region.span.longitudeDelta =  mapViewFromList.region.span.longitudeDelta * 1.5
        if (ClosetSportController.sharedInstance.infoLocalDic[key]?.distance)! >= 50 {
            alert(input: "You are too far from Toronto, Canada")
        }

    }



    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0

        return renderer
    }

    func sortKeysArrayByDistance(){

//        let storByDistance = self.stationInfo.infoLocalDic.sorted { (s1, s2) -> Bool in
        let storByDistance = ClosetSportController.sharedInstance.infoLocalDic.sorted { (s1,s2) -> Bool in
            return s1.value.distance < s2.value.distance
        }

        var keys = [String]()

        for i in storByDistance {

            keys.append(i.key)
        }

        ClosetSportController.sharedInstance.keysArray = keys

    }

    func checkCellTextColor(cell: ClosestSpotCell,bikes:Int, docks:Int, distance:Double) {

        cell.bikesAvailable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if bikes == 0 {
            cell.bikesAvailable.textColor = UIColor.red
        }else if bikes >= 1 && bikes <= 3 {
            cell.bikesAvailable.textColor = UIColor.orange
        }

        cell.docksAvailable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if docks == 0 {
            cell.docksAvailable.textColor = UIColor.red
        }else if docks >= 1 && docks <= 3 {
            cell.docksAvailable.textColor = UIColor.orange
        }

        cell.distancelable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if distance >= 10.0 && distance <= 20.0 {
            cell.distancelable.textColor = UIColor.orange
        }else if distance >= 20.1 {
            cell.distancelable.textColor = UIColor.red
        }


    }
    
}

